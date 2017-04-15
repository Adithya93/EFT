library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity ValidRegFile is
	port(
			DATA_IN: 							in std_logic;
			reg_select:							in std_logic_vector(5 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2: 	in std_logic;
			regDataOut:							out std_logic_vector(63 downto 0));
end ValidRegFile;


architecture imp_tableEntries of ValidRegFile is 
	
	COMPONENT DFFE
   PORT (d   : IN STD_LOGIC;

        clk  : IN STD_LOGIC;

        clrn : IN STD_LOGIC;

        prn  : IN STD_LOGIC;

        ena  : IN STD_LOGIC;

        q    : OUT STD_LOGIC );
	 end component;

	
	COMPONENT decoder_6to64
    PORT ( 
			  DATA_IN : IN  std_logic_vector (5 downto 0);  -- 5-bit input
           DATA_OUT  : OUT std_logic_vector (63 downto 0);  -- 32-bit output
           EN : IN  std_logic);                     -- enable input
	end component;
	
	
	
	signal decodeHash: std_logic_vector(63 downto 0);
	signal not_clrn_sig: std_logic;-- <= not clrn_sig2;
	signal not_prn_sig: std_logic;-- <= not prn_sig2;
	signal ena_sig_vec: std_logic_vector(63 downto 0);
	
	
	begin 
	
		not_clrn_sig <= not clrn_sig2;
		not_prn_sig <= not prn_sig2;
		
	
	tableEntriesDecoder: decoder_6to64 port map(DATA_IN => reg_select,
								DATA_OUT => decodeHash,
								EN => '1');
	
	
	-- use decoder to convert reg_select into 1-hot encoding
	
		GEN_REGS:
		for I in 0 to 63 generate
		begin
			ena_sig_vec(I) <= ena_sig2 and decodeHash(I);
			REGX: DFFE port map
			(d => DATA_IN, clk => clk_sig2, clrn => not_clrn_sig, ena => ena_sig_vec(I), prn => not_prn_sig, q => regDataOut(I));
			end generate GEN_REGS;
				
end architecture imp_tableEntries;