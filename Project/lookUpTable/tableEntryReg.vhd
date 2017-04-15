library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity tableEntryReg is
	port(
			regEntry: 					in std_logic_vector(47 downto 0);
			clk_sig, clr, ena_sig, prn_sig: 	in std_logic;
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
	 
	  signal not_clrn_sig, not_prn_sig: std_logic;
	 
	 begin
	 	not_clrn_sig <= not clr;
		not_prn_sig <= not prn_sig;
		GEN_REG:
		for I in 0 to 47 generate
			DFFE0: DFFE port map
			(d => regEntry(I), clk => clk_sig, clrn => not_clrn_sig, prn => not_prn_sig, ena => ena_sig, q => qOut(I));
		end generate GEN_REG;
end genReg;