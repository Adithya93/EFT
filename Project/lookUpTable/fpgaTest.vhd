library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity fpgaTest is
	port(
		clk: 						in std_logic;
		reset:					in std_logic;
		compareDone: 			in std_logic;
		hashNow:					in std_logic;
		identf:					in std_logic_vector(1 downto 0);
		addressNum:				in std_logic_vector(4 downto 0);
		destPort_display, state_display:				out std_logic_vector(6 downto 0);
		isHit:					out std_logic;
		isDone:					out std_logic);
	end fpgaTest;
	

architecture test of fpgaTest is
	component addrROM 
			PORT (
			address:						in std_logic_vector(4 downto 0);
			clock	:						in std_logic;
			q:								out std_logic_vector(47 downto 0));
	end component;
	
	component srcAddrROM 
			PORT (
			address:						in std_logic_vector(4 downto 0);
			clock	:						in std_logic;
			q:								out std_logic_vector(47 downto 0));
	end component;
	
	component srcPortROM
			PORT (
			address:						in std_logic_vector(4 downto 0);
			clock	:						in std_logic;
			q:								out std_logic_vector(9 downto 0));
	end component;
	
	 component segDisplay is
			port (
			clk : 							in std_logic;
			bcd : 							in std_logic_vector(3 downto 0);  
			segment7 : 						out std_logic_vector(6 downto 0) );
	end component;
	
	component hashTable 
		port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			reset:										 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			cAddrOne, cAddrTwo:						buffer std_logic_vector(47 downto 0);
			setRegAge:									out std_logic_vector(5 downto 0);
			compareLook,resetAgeing, isHit:						out std_logic;
			isDone:										out std_logic;
			state_num:									out std_logic_vector(2 downto 0));
	end component;
	
	signal srcAdd_out, destAdd_out:			std_logic_vector(47 downto 0);
	signal srcPort_out, destPort_out:			std_logic_vector(9 downto 0);
	signal cAddrOne_out, cAddrTwo_out:			std_logic_vector(47 downto 0);
	signal setRegAge_out:									std_logic_vector(5 downto 0);
	signal compareLook_out, raOut:										std_logic;
	signal state_num_out:						std_logic_vector(2 downto 0);
	
	
	begin
	
	U1: srcAddrROM PORT MAP(
			address => addressNum,
			clock	=> not clk,
			q => srcAdd_out);
	
	U2: addrROM PORT MAP(
			address => addressNum,
			clock	=> not clk,
			q => destAdd_out);
					
	U3: srcPortROM PORT MAP(
			address => addressNum,
			clock	=> not clk,
			q => srcPort_out);
	
	U4: segDisplay PORT MAP(
			clk => not clk,
			bcd => destPort_out(9 downto 6),
			segment7 => destPort_display);
			
	U5: segDisplay PORT MAP(
			clk => not clk,
			bcd => '0' & state_num_out(2 downto 0),
			segment7 => state_display);
	
	U0: hashTable port map(compareDone => compareDone,
										ageOut => '0',
										clk => not clk,
										hashNow => hashNow,
										reset =>  not reset,
										srcAdd => srcAdd_out,
										destAddIn => destAdd_out,
										identf => identf,
										srcPort => srcPort_out,
										notValid => "000000",
										destPort => destPort_out,
										cAddrOne => cAddrOne_out,
										cAddrTwo => cAddrTwo_out,
										setRegAge => setRegAge_out,
										compareLook => compareLook_out,
										resetAgeing => raOut,
										isHit => isHit,
										isDone => isDone,
										state_num => state_num_out);
	end test;
			
		
		
