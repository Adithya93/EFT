library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity lookUpTable is
	port(
		srcAddr_sig, destAddrIn_sig:			in std_logic_vector(47 downto 0);
		srcPort_sig:								in std_logic_vector(9 downto 0);
		clk_sig, lookNowIn_sig:					in std_logic;
		reset_sig:									in std_logic;
		destPort_sig: 								out std_logic_vector(9 downto 0);
		isHit_sig:									out std_logic;
		lookNowOut_sig:							out std_logic;
		glob_timer_sig:							out std_logic_vector(9 downto 0);
		identf_sig:									buffer std_logic_vector(1 downto 0);
		da_sig:										buffer std_logic_vector(47 downto 0);
		addr1_sig:										buffer std_logic_vector(47 downto 0);
		addr2_sig:										buffer std_logic_vector(47 downto 0);
		state_num:										buffer std_logic_vector(2 downto 0));
end lookUpTable;

architecture mult_subsystem of lookUpTable is
	component hashTable 
		port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			reset:										 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			cAddrOne, cAddrTwo:		buffer std_logic_vector(47 downto 0);
			setRegAge:									out std_logic_vector(5 downto 0);
			compareLook, resetAgeing, isHit:		out std_logic;
			hashVal:								buffer std_logic_vector(4 downto 0);
			crc_reset:							buffer std_logic;
			isDone:										out std_logic);
	end component;

	component comparator
		port(
			clk_sig:		in std_logic;
			reset_sig:	in std_logic;
			da:		in std_logic_vector(47 downto 0);
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic;
			compStart: in std_logic);
		end component;
		

	component agingModule is
		port (
			clk, global_reset: in std_logic;
			look_now: in std_logic;
			set_reg_age: in std_logic_vector(5 downto 0);
			age_out_now: out std_logic;
			age_out_reg: out std_logic_vector(5 downto 0);
			glob_timer:	 out std_logic_vector(9 downto 0));
		end component;
		
		signal compDone_sig, resetAgeing_sig, ageOut_sig: 		std_logic;
		--signal addr1_sig, addr2_sig: 									std_logic_vector(47 downto 0);
		--signal identf_sig:												std_logic_vector(1 downto 0);
		signal notValid_sig: 											std_logic_vector(5 downto 0);
		signal setRegAge_sig:											std_logic_vector(5 downto 0);
		signal compareLook_sig:											std_logic;
		--signal da_sig:														std_logic_vector(47 downto 0);
		signal destPort_latch:											std_logic_vector(9 downto 0);
		signal isDone:														std_logic;
		signal isHit_latch:												std_logic;
		signal keepHit:													std_logic;
		--signal hashVal_sig:												std_logic_vector(4 downto 0);
		
		type state_type is
			(P, Q, R, S, T, U, V);
		signal state_reg, state_next: state_type;

		
		
		begin
		U0: hashTable port map(compareDone => compDone_sig,
										ageOut => ageOut_sig,
										clk => clk_sig,
										hashNow => lookNowIn_sig,
										reset => reset_sig,
										srcAdd => srcAddr_sig,
										destAddIn => destAddrIn_sig,
										identf => identf_sig,
										srcPort => srcPort_sig,
										notValid => notValid_sig,
										destPort => destPort_latch,
										--destAddOut => destAddrOut_sig,
										cAddrOne => addr1_sig,
										cAddrTwo => addr2_sig,
										setRegAge => setRegAge_sig,
										compareLook => compareLook_sig,
										resetAgeing => resetAgeing_sig,
										isHit => isHit_latch,
										isDone => isDone);
										
		U1: comparator port map(clk_sig => clk_sig,
										reset_sig => reset_sig,
										da =>		da_sig, -- needs to get assigned to DA & SA based on cycle, through FSM
										addr1 => addr1_sig,
										addr2 => addr2_sig,
										compResult => identf_sig,
										compDone => compDone_sig,
										compStart =>	compareLook_sig);
										
		U2: agingModule port map(clk => clk_sig,
										 global_reset => reset_sig,
										 look_now => resetAgeing_sig,
										 set_reg_age => setRegAge_sig,
										 age_out_now => ageOut_sig,
										 age_out_reg => notValid_sig,
										 glob_timer => glob_timer_sig);
		process(clk_sig, reset_sig)
		begin
			if(reset_sig = '1') then state_reg <= P;
			elsif (clk_sig'event and clk_sig = '1') then 
				state_reg <= state_next;
			end if;
		end process;
		
		process(state_reg, lookNowIn_sig, isDone, destAddrIn_sig, srcAddr_sig, isHit_latch, destPort_latch, keepHit)
		begin
		isHit_sig <= keepHit;
			case state_reg is
				when P => 
					if(lookNowIn_sig = '1') then
						state_next <= Q;
						da_sig <= destAddrIn_sig;
						isHit_sig <= '0';
					else
						state_next <= P;
						isHit_sig <= '0';
					end if;
				when Q =>
					if(isDone = '1') then
						state_next <= R;
						destPort_sig <= destPort_latch;
						if(isHit_latch = '1') then
							keepHit <= '1';
						else
							keepHit <= '0';
						end if;
					else
						state_next <= Q;
						isHit_sig <='0';
					end if;
				when R =>
						state_next <= S;
						da_sig <= srcAddr_sig;
				when S =>
					state_next <= T;
				when T => 
					state_next <= U;
				when U => 
					state_next <= V;
				when V =>
					state_next <= P;
					destPort_sig <= "0000000000";
					isHit_sig <= '0';
				end case;
			end process;	

		process(state_reg)
		begin
			case state_reg is
			when P =>
				lookNowOut_sig <= '0';
				state_num <= "000";
			when Q =>
				lookNowOut_sig <= '0';
				state_num <= "001";
			when R =>
				lookNowOut_sig <= '1';
				state_num <= "010";
			when S =>
				lookNowOut_sig <= '0';
				state_num <= "011";
			when T =>
				lookNowOut_sig <= '0';
				state_num <= "100";
			when U =>
				lookNowOut_sig <= '0';
				state_num <= "101";
			when V =>
				lookNowOut_sig <= '0';
				state_num <= "110";
			end case;
		end process;
		
	end mult_subsystem;