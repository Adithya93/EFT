library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity tableEntries is
	port(
			regEntry: 					in std_logic_vector(47 downto 0);
			hashVal:						in std_logic_vector(4 downto 0);
			clk, clrn, ena, prn: 	in std_logic;
			regDataOut:								out std_logic_vector(47 downto 0));
end tableEntries;


architecture imp_tableEntries of tableEntries is 
	
	COMPONENT tableEntryReg
	PORT(
			regEntry: 					IN std_logic_vector(47 downto 0);
			clk:							IN std_logic;
			clrn:							IN std_logic;
			ena:							IN std_logic; 
			prn: 							IN std_logic;
			qOut:							OUT std_logic_vector(47 downto 0));
	end component;

	
	signal decodeHash: std_logic_vector(0 to 31);
	
	begin
		GEN_REGS:
		for I in 0 to 31 generate
			REGX: tableEntryReg port map
			(regEntry, clk, clrn, prn, decodeHash(I), regDataOut);
		end generate GEN_REGS;

end architecture imp_tableEntries;