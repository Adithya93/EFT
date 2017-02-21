library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity lookUpTable is
	port(
		srcAddr_sig, destAddrIn_sig:			in std_logic_vector(47 downto 0);
		srcPort_sig:								in std_logic_vector(9 downto 0);
		clk_sig, lookNowIn_sig:					in std_logic;
		destAddrOut_sig:							out std_logic_vector(47 downto 0);
		destPort_sig: 								out std_logic_vector(9 downto 0);
		isHit_sig, lookNowOut_sig:				out std_logic);
end lookUpTable;

architecture mult_subsystem of lookUpTable is
	component hashTable 
		port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			destAddOut, cAddrOne, cAddrTwo:		out std_logic_vector(47 downto 0);
			resetAgeing, isHit:						out std_logic);
	end component;

	component comparator
		port(
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic);
		end component;
		
--	component ageing
--		port(
--		
--		);
--		end component;
		
		signal compDone_sig, resetAgeing_sig, ageOut_sig: 		std_logic;
		signal addr1_sig, addr2_sig: 									std_logic_vector(47 downto 0);
		signal identf_sig:												std_logic_vector(1 downto 0);
		signal notValid_sig: 											std_logic_vector(5 downto 0);
		
		begin
		U0: hashTable port map(compareDone => compDone_sig,
										ageOut => ageOut_sig,
										clk => clk_sig,
										hashNow => lookNowIn_sig,
										srcAdd => srcAddr_sig,
										destAddIn => destAddrIn_sig,
										identf => identf_sig,
										srcPort => srcPort_sig,
										notValid => notValid_sig,
										destPort => destPort_sig,
										destAddOut => destAddrOut_sig,
										cAddrOne => addr1_sig,
										cAddrTwo => addr2_sig,
										resetAgeing => resetAgeing_sig,
										isHit => isHit_sig);
										
		U1: comparator port map(addr1 => addr1_sig,
										addr2 => addr2_sig,
										compResult => identf_sig,
										compDone => compDone_sig);
										
--		U2: ageing port map( );
	end mult_subsystem;