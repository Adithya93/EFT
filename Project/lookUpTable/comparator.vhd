library ieee;
use ieee.std_logic_1164.all;


entity comparator is 

	port (
		addr1:	in std_logic_vector(47 downto 0);
		addr2:	in std_logic_vector(47 downto 0);
		compResult:	out std_logic_vector(1 downto 0);
		compDone:	out std_logic
	);
	
	end comparator;
	
	
	architecture comp of comparator is
	
	
	
	begin
	
	
	end comp;