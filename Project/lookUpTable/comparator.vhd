library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity comparator is
		port(
			da: 		in std_logic_vector(47 downto 0);
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic;
			compStart: 	in std_logic);
end comparator;

architecture comparator_arch of comparator is
signal comp1     : std_logic;
signal comp2     : std_logic;
signal greater1     : std_logic;
signal equal1     : std_logic;
signal less1     : std_logic;
signal greater2     : std_logic;
signal equal2     : std_logic;
signal less2     : std_logic;
--	SIGNAL comp1, comp2, greater1, equal1, less1, greater2, equal2, less2;
begin
	process(da, addr1)
	begin
	if compStart = '1' then
		comp1 <= '0';
		greater1 <= '0';
		equal1 <= '0';
		less1 <= '0';
		compResult(0) <= '0';
		if (da > addr1) then
			greater1 <= '1';
		elsif (da = addr1) then
			equal1 <= '1';
			compResult(0) <= '1';
		elsif (da < addr1) then
			less1 <= '1';
		end if;
		comp1 <= '1';
		end if;
	end process;
	
	process(da, addr2)
	begin
	if compStart = '1' then
		comp2 <= '0';
		greater2 <= '0';
		equal2 <= '0';
		less2 <= '0';
		compResult(1) <= '0';
		if (da > addr2) then
			greater2 <= '1';
		elsif (da = addr2) then
			equal2 <= '1';
			compResult(1) <= '1';
		elsif (da < addr2) then
			less2 <= '1';
		end if;
		comp2 <= '1';
		end if;
	end process;
	
	process(comp1, comp2)
	begin
		if (comp1 = '1' and comp2 = '1') then
			compDone <= '1';
		end if;
	end process;
end comparator_arch;