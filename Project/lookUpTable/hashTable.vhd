library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;
use ieee.numeric_std.all;

entity hashTable is
	port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			reset:										 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			--destAddOut, cAddrOne, cAddrTwo:		out std_logic_vector(47 downto 0);
			cAddrOne, cAddrTwo:		out std_logic_vector(47 downto 0);
			setRegAge:									out std_logic_vector(5 downto 0);
			compareLook, resetAgeing, isHit:		out std_logic);
end hashTable;
		
architecture hashing of hashTable is 
	component tableEntries
		port(
			DATA_IN: 					in std_logic_vector(47 downto 0);
			reg_select:						in std_logic_vector(4 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2: 	in std_logic;
			regDataOut:					out std_logic_vector(47 downto 0));
	end component;

	component crc
		port ( 
			data_in : in std_logic_vector (15 downto 0);
			crc_en , rst, clk : in std_logic;
			crc_out : out std_logic_vector (4 downto 0));
	end component;
	
	-- A 32-bit register for keeping track of LRU of each bucket
	component LRURegFile
		port(
			DATA_IN: 					in std_logic;
			reg_select:						in std_logic_vector(4 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2: 	in std_logic;
			regDataOut:					out std_logic);
	
	end component;
	
	-- A 64-bit register for keeping track of valid (expired) bits
	component ValidRegFile
		port(
			DATA_IN:						in std_logic;
			reg_select:						in std_logic_vector(5 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2:	in std_logic;
			regDataOut:					out std_logic_vector(63 downto 0));
	end component;
	
	component tablePorts
		port(
			DATA_IN: 					in std_logic_vector(9 downto 0);
			reg_select:						in std_logic_vector(4 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2:	in std_logic;
			regDataOut:					out std_logic_vector(9 downto 0));
	end component;
	
	
	type state_type is
		(A, B, C, D, E, F, G, H);
	signal state_reg, state_next: state_type;
	--signal crc_out1, crc_out2: std_logic_vector(4 downto 0);
	signal crc_in : std_logic_vector(15 downto 0);
	signal crc_out : std_logic_vector(4 downto 0);
	signal hashVal : std_logic_vector(4 downto 0);
	
	signal bucket_entry1_in, bucket_entry2_in: std_logic_vector(47 downto 0);
	signal bucket_entry1_out, bucket_entry2_out: std_logic_vector(47 downto 0);
	--signal table_we1, table_we2, crc_enaSA, crc_enaDA : std_logic;
	signal table_we1, table_we2, crc_ena : std_logic;
	
	-- For storing port info 
	signal bucket_ports1_in, bucket_ports2_in: std_logic_vector(9 downto 0);
	signal bucket_ports1_out, bucket_ports2_out: std_logic_vector(9 downto 0);
	-- use same w/e as table_we1 and table_we2 respectively ? or not 
	signal ports_we1, ports_we2 : std_logic;
	
	-- For LRU bits
	signal lru_in : std_logic;
	signal lru_out: std_logic;
	signal lru_enable: std_logic;

	signal valid_regfile_out : std_logic_vector(63 downto 0);
	signal valid_regfile_in: std_logic;
	signal valid_regfile_reg: std_logic_vector(5 downto 0);
	signal valid_we: std_logic;
	

	begin
		
		--CRC1: crc port map(data_in => destAddIn(47 downto 32),
		CRC1: crc port map(data_in => crc_in,
--								crc_en => crc_enaDA,
								crc_en => crc_ena,
								rst => reset,
								clk => clk,
--								crc_out => crc_out1);
								crc_out => crc_out);
								
		--CRC2: crc port map(data_in => srcAdd(47 downto 32),
		--						crc_en => crc_enaSA,
		--						rst => reset,
		--						clk => clk,
		--						crc_out => crc_out2);
		
		regEntry1: tableEntries port map(DATA_IN => bucket_entry1_in,
													reg_select => hashVal, 
													clk_sig2 => clk,
													clrn_sig2 => reset,
													ena_sig2 => table_we1,
													prn_sig2 => '0',
													regDataOut => bucket_entry1_out);
		regEntry2: tableEntries port map(DATA_IN => bucket_entry2_in,
													reg_select => hashVal, -- if there are 2 crcs, need a signal to determine whose hashVal output to take
													clk_sig2 => clk,
													clrn_sig2 => reset,
													ena_sig2 => table_we2,
													prn_sig2 => '0',
													regDataOut => bucket_entry2_out); 
		regPorts1:	tablePorts port map(DATA_IN => bucket_ports1_in,
												  reg_select => hashVal,
												  clk_sig2 => clk,
												  clrn_sig2 => reset,
												  --ena_sig2 => table_we1,
												  ena_sig2 => ports_we1,
												  prn_sig2 => '0',
												  regDataOut => bucket_ports1_out);
		
		regPorts2:	tablePorts port map(DATA_IN => bucket_ports2_in,
												  reg_select => hashVal,
												  clk_sig2 => clk,
												  clrn_sig2 => reset,
												  --ena_sig2 => table_we2,
												  ena_sig2 => ports_we2,
												  prn_sig2 => '0',
												  regDataOut => bucket_ports2_out);
		
		
		lruReg: LRURegFile port map(DATA_IN => lru_in,
											 reg_select => hashVal,
											 clk_sig2 => clk,
											 clrn_sig2 => reset,
											 ena_sig2 => lru_enable,
											 prn_sig2 => '0',
											 regDataOut => lru_out);
											 
		validReg: ValidRegFile port map(DATA_IN => valid_regfile_in,
												  reg_select => valid_regfile_reg,
												  clk_sig2 => clk,
												  clrn_sig2 => reset,
												  ena_sig2 => valid_we,
												  prn_sig2 => '0',
												  regDataOut => valid_regfile_out);
													
			
		process(clk, reset)
		begin
			if(reset = '1') then state_reg <= A;
			elsif (clk'event and clk = '1') then 
				state_reg <= state_next;
			end if;
		end process;
		
		process(state_reg, hashNow, compareDone, ageOut)
		begin
			case state_reg is
				when A => 
					if(hashNow = '1') then
						state_next <= B;
					else
						state_next <= A;
					end if;
				when B =>
					state_next <= C;
				when C =>
					if(compareDone = '1') then
						state_next <= D;
					else
						state_next <= C;
					end if;
				when D =>
					state_next <= E;
				when E => 
					state_next <= F;
				when F => 
					if(compareDone = '1') then
						state_next <= G;
					else
						state_next <= F;
					end if;
				when G =>
					state_next <= H;
				when H =>
					state_next <= A;
					
				end case;
			end process;					
	
		process(state_reg, ageOut, identf, crc_out, bucket_entry1_out, bucket_entry2_out, srcAdd, notValid, valid_regfile_out, hashVal, lru_in, lru_out, valid_we, valid_regfile_in, valid_regfile_reg, bucket_ports1_out, bucket_ports2_out, srcPort)
		begin 
			-- set default values to prevent inferred latch?
			--lru_enable <= '0';
			--lru_in <= '0'; -- doesn't really matter in light of the above line, but just in case
			-- should do the same for other signals being assigned below?
			--valid_we <= '0';
			--valid_regfile_in <= '0';
			case state_reg is
			when A =>
				if(ageOut = '1') then -- sufficient to check only at one stage of the FSM since ageOut spans many rounds
					-- set valid bit to invalid
					valid_we <= '1';
					valid_regfile_in <= '0';
					valid_regfile_reg <= notValid;-- use notValid signal to write into valid_bits register
				end if;
			when B =>

--				crc_enaDA <= '1';
--				crc_enaSA <= '0';
				crc_ena <= '1';
				
				crc_in <= destAddIn(47 downto 32);
				
				compareLook <= '0';
				isHit <= '0';
				valid_we <= '0';
			when C =>
				--send to comparator and wait;
--				hashVal <= crc_out1;
				hashVal <= crc_out; -- need to use blocking assignment?
				cAddrOne <= bucket_entry1_out;
				cAddrTwo <= bucket_entry2_out;
--				crc_enaDA <= '0';
--				crc_enaSA <= '0';
				crc_ena <= '0';
				compareLook <= '1';
				isHit <= '0';
			when D =>
				--send destination result + update LRU
--				crc_enaDA <= '0';
--				crc_enaSA <= '0';
				crc_ena <= '0';
				compareLook <= '0';
--				if(identf = "01" or identf = "10") then
--					isHit <= '1'; --TBD
					-- Update LRU to be 
--				else
--					isHit <= '0';
--				end if;
				-- update LRU for read if hit, same with resetting of ageing
				if(identf = "01" and valid_regfile_out(to_integer(unsigned(hashVal & '1'))) = '1') then
					isHit <= '1';
					
					-- set destPort to be port saved in table
					destPort <= bucket_ports2_out;
					
					lru_enable <= '1';
					lru_in <= '1';
					
					resetAgeing <= '1'; -- tell ageing subsystem to write-enable
					setRegAge <= hashVal & lru_in;
					
					valid_we <= '1';
					valid_regfile_in <= '1'; -- just used value, will be valid
					valid_regfile_reg <= hashVal & lru_in;
					
					
				elsif(identf = "10" and valid_regfile_out(to_integer(unsigned(hashVal & '0'))) = '1') then
					isHit <= '1';
					
					-- set destPort to be port saved in table
					destPort <= bucket_ports1_out;
					
					lru_enable <= '1';
					lru_in <= '0';
					
					resetAgeing <= '1'; -- tell ageing subsystem to write-enable
					setRegAge <= hashVal & lru_in;
					
					valid_we <= '1';
					valid_regfile_in <= '1'; -- just used value, will be valid
					valid_regfile_reg <= hashVal & lru_in;
					
				else -- miss
					lru_enable <= '0';
					isHit <= '0';
				end if;
					
			when E => 
				--hashval from srcAdd
--				crc_enaDA <= '0';
--				crc_enaSA <= '1';
				crc_ena <= '1';
				
				crc_in <= srcAdd(47 downto 32);
				
				compareLook <= '0';
				isHit <= '0';
				
				lru_enable <= '0';
				resetAgeing <= '0';
				valid_we <= '0';
				
			when F =>
				--send to comparator and wait;
--				hashVal <= crc_out2;
				hashVal <= crc_out;
				cAddrOne <= bucket_entry1_out;
				cAddrTwo <= bucket_entry2_out;
--				crc_enaDA <= '0';
--				crc_enaSA <= '0';
				crc_ena <= '0';
				compareLook <= '1';
								
			when G =>
				-- Update LRU for writing of SA
				lru_enable <= '1';
				-- Update Ageing for writing of SA
				resetAgeing <= '1';
				-- Update Valid bits for writing of SA
				valid_we <= '1';
				
				--store source address (if need be)				
				if(identf = "00") then		
--					isHit <= '0'; -- Hit doesn't apply to Source Address right?
					-- need to write the SA into whichever is the LRU
--					bucket_entry1_in <= srcAdd;		
--					table_we1 <= '1';		
					if(lru_out = '0') then -- lru is bucket_entry1
						bucket_entry1_in <= srcAdd;
						table_we1 <= '1';
						table_we2 <= '0';
						
						-- store srcPort in table
						ports_we1 <= '1';
						ports_we2 <= '0';
						bucket_ports1_in <= srcPort;
						
						lru_in <= '1'; -- lru will be bucket_entry2 on next cycle
						setRegAge <= hashVal & lru_out; -- reset age of bucket_entry1 as it is being written to
						valid_regfile_in <= '1';
						valid_regfile_reg <= hashVal & lru_out;
					else -- lru is bucket_entry2
						bucket_entry2_in <= srcAdd;
						table_we1 <= '0';
						table_we2 <= '1';
						
						-- store srcPort in table
						ports_we1 <= '0';
						ports_we2 <= '1';
						bucket_ports2_in <= srcPort;
						
						lru_in <= '0'; -- lru will be bucket_entry1 on next cycle
						setRegAge <= hashVal & lru_out; -- reset age of bucket_entry2 as it is being written to
						valid_regfile_in <= '1';
						valid_regfile_reg <= hashVal & lru_out;
					end if;
				elsif(identf = "01") then -- just update lru & ageing, but dont need to write into entry		
					table_we1 <= '0';
					table_we2 <= '0';
					
					-- overwrite port for given address
					ports_we1 <= '0';
					ports_we2 <= '1';
					bucket_ports2_in <= srcPort;
					
					lru_in <= '1'; -- lru will be bucket_entry2 on next cycle
					setRegAge <= hashVal & lru_in; -- reset age of bucket_entry2 as it was just used
					valid_regfile_in <= '1';
					valid_regfile_reg <= hashVal & lru_in;
				else -- must be "10"
					table_we1 <= '0';
					table_we2 <= '0';
					
					-- overwrite port for given address
					ports_we1 <= '1';
					ports_we2 <= '0';
					bucket_ports1_in <= srcPort;
					
					lru_in <= '0'; -- lru will be bucket_entry1 on next cycle
					setRegAge <= hashVal & lru_in; -- reset age of bucket_entry1 as it was just used
					valid_regfile_in <= '1';
					valid_regfile_reg <= hashVal & lru_in;
				end if;
--				crc_enaDA <= '0';
--				crc_enaSA <= '0';
				crc_ena <= '0';
				compareLook <= '0';
--				isHit <= '0';
			when H =>
				lru_enable <= '0';
				resetAgeing <= '0';
				valid_we <= '0';
				table_we1 <= '0';
				table_we2 <= '0';
				ports_we1 <= '0';
				ports_we2 <= '0';
--				valid_we <= '1';
--				valid_regfile_in <= '1';
				--valid_regfile_reg <= TBD
--				table_we1 <= '0';
--				setRegAge <= "000000"; --Set Reg Age for entry that was either newly written or read from cache
--				resetAgeing <= '1'; --TBD
			end case;
		end process;
	
	end hashing;