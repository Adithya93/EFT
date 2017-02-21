library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity tableEntryReg is
	port(
			regEntry: 					in std_logic_vector(47 downto 0);
			clk, clrn, ena, prn: 	in std_logic;
			qOut:								out std_logic_vector(47 downto 0));
end tableEntryReg;

architecture genReg of tableEntryReg is
	COMPONENT DFFE
   PORT (d   : IN STD_LOGIC;

        clk  : IN STD_LOGIC;

        clrn : IN STD_LOGIC;

        prn  : IN STD_LOGIC;

        ena  : IN STD_LOGIC;

        q    : OUT STD_LOGIC );
	 end component;
	 
	 begin
		GEN_REG:
		for I in 0 to 31 generate
			DFFE0: DFFE port map
			(regEntry(I), clk, clrn, prn, ena, qOut(I));
		end generate GEN_REG;
end genReg;