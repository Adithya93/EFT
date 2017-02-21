library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity hashTable is
	port(
			compareDone, ageOut, clk, hashNow:	 in std_logic;
			srcAdd, destAddIn:						 in std_logic_vector(47 downto 0);
			identf:										 in std_logic_vector(1 downto 0);
			srcPort:										 in std_logic_vector(9 downto 0);
			notValid: 									 in std_logic_vector(5 downto 0);
			destPort:									out std_logic_vector(9 downto 0);
			destAddOut, cAddrOne, cAddrTwo:		out std_logic_vector(47 downto 0);
			resetAgeing, isHit:						out std_logic);
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

	begin
	
	
	end hashing;