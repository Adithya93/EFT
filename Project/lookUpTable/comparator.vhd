library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity comparator is
		port(
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic);
end comparator;

architecture comparator_arch of comparator is
begin
	process(da, addr1, compResult, compDone)
	begin
		comp1 <= '0';
		greater <= '0'
		equal <= '0'
		less <= '0'
		if (da > addr1) then
			greater <= '1';
			compResult[0] <= '0';
		elsif (da = addr1) then
			equal <= '1';
			compResult[0] <= '1';
		elsif (da < addr1) then
			less <= '1';
			compResult[0] <= '0';
		end if;
		comp1 <= '1';
		if (comp1 and comp2) then
			compDone <= '1';
		end if;		
	end process;
	
	process(da, addr2. compResult, compDone)
	begin
		comp2 <= '0';
		greater <= '0'
		equal <= '0'
		less <= '0'
		if (da > addr2) then
			greater <= '1';
			compResult[1] <= '0';
		elsif (da = addr2) then
			equal <= '1';
			compResult[1] <= '1';
		elsif (da < addr2) then
			less <= '1';
			compResult[1] <= '0';
		end if;
		comp2 <= '1';
		if (comp1 and comp2) then
			compDone <= '1';
		end if;
	end process;
end comparator_arch;