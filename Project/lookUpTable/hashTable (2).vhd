library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity hashTable is
	port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			reset:										 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			destAddOut, cAddrOne, cAddrTwo:		out std_logic_vector(47 downto 0);
			setRegAge:									out std_logic_vector(5 downto 0);
			compareLook, resetAgeing, isHit:		out std_logic);
end hashTable;
		
architecture hashing of hashTable is 
	component tableEntries
		port(
			regEntry: 					in std_logic_vector(47 downto 0);
			hashVal:						in std_logic_vector(4 downto 0);
			clk, clrn, ena, prn: 	in std_logic;
			regDataOut:					out std_logic_vector(47 downto 0));
	end component;

	component crc
		port ( 
			data_in : in std_logic_vector (15 downto 0);
			crc_en , rst, clk : in std_logic;
			crc_out : out std_logic_vector (4 downto 0));
	end component;

	type state_type is
		(A, B, C, D, E, F);
	signal state_reg, state_next: state_type;
	signal crc_out1, crc_out2: std_logic_vector(4 downto 0);
	signal hashVal: std_logic_vector(4 downto 0);
	
	signal bucket_entry1_in, bucket_entry2_in: std_logic_vector(47 downto 0);
	signal bucket_entry1_out, bucket_entry2_out: std_logic_vector(47 downto 0);
	signal table_we1, table_we2, crc_enaSA, crc_enaDA : std_logic;
	
	signal valid_regfile_out : std_logic;
	signal valid_regfile_in: std_logic;
	signal valid_regfile_reg: std_logic_vector(5 downto 0);
	signal valid_we: std_logic;
	

	begin
		
		CRC1: crc port map(data_in => destAddIn(47 downto 32),
								crc_en => crc_enaDA,
								rst => reset,
								clk => clk,
								crc_out => crc_out1);
								
		CRC2: crc port map(data_in => srcAdd(47 downto 32),
								crc_en => crc_enaSA,
								rst => reset,
								clk => clk,
								crc_out => crc_out2);
		
		regEntry1: tableEntries port map(DATA_IN => bucket_entry1_in,
													reg_select => hashVal, -- if there are 2 crcs, need a signal to determine whose hashVal output to take
													clk => clk,
													clrn => reset,
													ena => table_we1,
													prn => '0',
													regDataOut => bucket_entry1_out);
		regEntry2: tableEntries port map(DATA_IN => bucket_entry2_in,
													reg_select => hashVal, -- if there are 2 crcs, need a signal to determine whose hashVal output to take
													clk => clk,
													clrn => reset,
													ena => table_we2,
													prn => '0',
													regDataOut => bucket_entry2_out); 
													
		valid_regfile: validReg port map(DATA_IN => valid_regfile_in,
													reg_select => valid_regfile_reg,
													clk => clk,
													clrn => reset,
													ena => valid_we,
													prn => '0',
													regDataOut => valid_regfile_out); -- how to handle issue of both agingModule and hashTable wanting to write at same time?
			
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
	
		process(state_reg, ageOut, identf)
		begin 
			case state_reg is
			when A =>
				if(ageOut = '1') then
					-- set valid bit to invalid
					valid_we <= '1';
					valid_regfile_in <= '0';
					valid_regfile_reg <= notValid;-- use notValid signal to write into valid_bits register
				end if;
			when B =>
				crc_enaDA <= '1';
				crc_enaSA <= '0';
				compareLook <= '0';
				isHit <= '0';
			when C =>
				--send to comparator and wait;
				hashVal_sig <= crc_out1;
				cAddrOne <= regDataOut1;
				cAddrTwo <= regDataOut2;
				crc_enaDA <= '0';
				crc_enaSA <= '0';
				compareLook <= '1';
				isHit <= '0';
			when D =>
				--send destination result + update LRU
				crc_enaDA <= '0';
				crc_enaSA <= '0';
				compareLook <= '0';
				isHit <= '1'; --TBD
			when E => 
				crc_enaDA <= '0';
				crc_enaSA <= '1';
				compareLook <= '0';
				isHit <= '0';
			when F =>
				--send to comparator and wait;
				hashVal_sig <= crc_out2;
				cAddrOne <= regDataOut1;
				cAddrTwo <= regDataOut2;
				crc_enaDA <= '0';
				crc_enaSA <= '0';
				compareLook <= '1';
				isHit <= '0';
				if(identf = "00") then		
					bucket_entry1_in <= srcAdd;		
					table1_we <= '1';		
				else		
					table1_we <= '0';		
				end if;
				
			when G =>
				--store source address (if need be)
				crc_enaDA <= '0';
				crc_enaSA <= '0';
				compareLook <= '0';
				isHit <= '0';
			when H =>
				valid_we <= '1';
				valid_regfile_in <= '1';
				--valid_regfile_reg <= TBD
				--send ageing info to age;
				setRegAge <= '0'; --TBD
				resetAgeing <= '1'; --TBD
			end case;
		end process;
	
	end hashing;