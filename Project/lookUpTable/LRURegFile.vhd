library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity LRURegFile is
	port(
			DATA_IN: 							in std_logic;
			reg_select:							in std_logic_vector(4 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2: 	in std_logic;
			regDataOut:								out std_logic);
end LRURegFile;


architecture imp_tableEntries of LRURegFile is 
	
	COMPONENT DFFE
   PORT (d   : IN STD_LOGIC;

        clk  : IN STD_LOGIC;

        clrn : IN STD_LOGIC;

        prn  : IN STD_LOGIC;

        ena  : IN STD_LOGIC;

        q    : OUT STD_LOGIC );
	 end component;

	
	COMPONENT decoder_5to32
    PORT ( 
			  DATA_IN : IN  std_logic_vector (4 downto 0);  -- 5-bit input
           DATA_OUT  : OUT std_logic_vector (31 downto 0);  -- 32-bit output
           EN : IN  std_logic);                     -- enable input
	end component;
	
	
	
	signal decodeHash: std_logic_vector(0 to 31);
	
	type reg_outputs is array (0 to 31) of std_logic;
	signal regOutputs : reg_outputs;
		
	signal not_clrn_sig, not_prn_sig: std_logic;
	signal ena_sig_vec : std_logic_vector(31 downto 0);
		
	begin 
---	regDataOut <= triStateOutputs;
	
		regDataOut <= regOutputs(0) when decodeHash(0) = '1' else 'Z';
		regDataOut <= regOutputs(1) when decodeHash(1) = '1' else 'Z';
		regDataOut <= regOutputs(2) when decodeHash(2) = '1' else 'Z';
		regDataOut <= regOutputs(3) when decodeHash(3) = '1' else 'Z';
		regDataOut <= regOutputs(4) when decodeHash(4) = '1' else 'Z';
		regDataOut <= regOutputs(5) when decodeHash(5) = '1' else 'Z';
		regDataOut <= regOutputs(6) when decodeHash(6) = '1' else 'Z';
		regDataOut <= regOutputs(7) when decodeHash(7) = '1' else 'Z';
		regDataOut <= regOutputs(8) when decodeHash(8) = '1' else 'Z';
		regDataOut <= regOutputs(9) when decodeHash(9) = '1' else 'Z';
		regDataOut <= regOutputs(10) when decodeHash(10) = '1' else 'Z';
		regDataOut <= regOutputs(11) when decodeHash(11) = '1' else 'Z';
		regDataOut <= regOutputs(12) when decodeHash(12) = '1' else 'Z';
		regDataOut <= regOutputs(13) when decodeHash(13) = '1' else 'Z';
		regDataOut <= regOutputs(14) when decodeHash(14) = '1' else 'Z';
		regDataOut <= regOutputs(15) when decodeHash(15) = '1' else 'Z';
		regDataOut <= regOutputs(16) when decodeHash(16) = '1' else 'Z';
		regDataOut <= regOutputs(17) when decodeHash(17) = '1' else 'Z';
		regDataOut <= regOutputs(18) when decodeHash(18) = '1' else 'Z';
		regDataOut <= regOutputs(19) when decodeHash(19) = '1' else 'Z';
		regDataOut <= regOutputs(20) when decodeHash(20) = '1' else 'Z';
		regDataOut <= regOutputs(21) when decodeHash(21) = '1' else 'Z';
		regDataOut <= regOutputs(22) when decodeHash(22) = '1' else 'Z';
		regDataOut <= regOutputs(23) when decodeHash(23) = '1' else 'Z';
		regDataOut <= regOutputs(24) when decodeHash(24) = '1' else 'Z';
		regDataOut <= regOutputs(25) when decodeHash(25) = '1' else 'Z';
		regDataOut <= regOutputs(26) when decodeHash(26) = '1' else 'Z';				
		regDataOut <= regOutputs(27) when decodeHash(27) = '1' else 'Z';
		regDataOut <= regOutputs(28) when decodeHash(28) = '1' else 'Z';
		regDataOut <= regOutputs(29) when decodeHash(29) = '1' else 'Z';
		regDataOut <= regOutputs(30) when decodeHash(30) = '1' else 'Z';
		regDataOut <= regOutputs(31) when decodeHash(31) = '1' else 'Z';
		
	
	tableEntriesDecoder: decoder_5to32 port map(DATA_IN => reg_select,
								DATA_OUT => decodeHash,
								EN => '1');
	not_clrn_sig <= not clrn_sig2;
	not_prn_sig <= not prn_sig2;
	
	-- use decoder to convert reg_select into 1-hot encoding
	
		GEN_REGS:
		for I in 0 to 31 generate
		begin
			ena_sig_vec(I) <= ena_sig2 and decodeHash(I);
			REGX: DFFE port map
			(d => DATA_IN, clk => clk_sig2, clrn => not_clrn_sig, ena => ena_sig_vec(I), prn => not_prn_sig, q => regOutputs(I));
		end generate GEN_REGS;
		
end architecture imp_tableEntries;