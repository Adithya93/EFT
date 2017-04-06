library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity agingRegFile is
	port(
			DATA_IN: 							in std_logic_vector(8 downto 0);
			reg_select_write:							in std_logic_vector(5 downto 0);
      reg_select_read:      in std_logic_vector(5 downto 0);
			clk_sig2, clrn_sig2, ena_sig2, prn_sig2: 	in std_logic;
			regDataOut:								out std_logic_vector(8 downto 0));
end agingRegFile;

architecture imp_agingRegFile of agingRegFile is 
	
	COMPONENT agingReg
	PORT(
			regEntry: 					IN std_logic_vector(8 downto 0);
			clk_sig:							IN std_logic;
			clr:							IN std_logic;
			ena_sig:							IN std_logic; 
			prn_sig: 							IN std_logic;
			qOut:							OUT std_logic_vector(8 downto 0));
	end component;

	
	COMPONENT decoder_6to64
    PORT ( 
          DATA_IN : IN  std_logic_vector (5 downto 0);    
          DATA_OUT  : OUT std_logic_vector (63 downto 0); 
          EN : IN  std_logic);                     
	end component;
	
	
	
	signal decodeHash: std_logic_vector(0 to 63);
  signal decodeWrite: std_logic_vector(0 to 63);
  
	type reg_outputs is array (0 to 63) of std_logic_vector(8 downto 0);
	signal regOutputs : reg_outputs;
	
begin
  
  regDataOut <= regOutputs(0) when decodeHash(0) = '1' else (others => 'Z');
regDataOut <= regOutputs(1) when decodeHash(1) = '1' else (others => 'Z');
regDataOut <= regOutputs(2) when decodeHash(2) = '1' else (others => 'Z');
regDataOut <= regOutputs(3) when decodeHash(3) = '1' else (others => 'Z');
regDataOut <= regOutputs(4) when decodeHash(4) = '1' else (others => 'Z');
regDataOut <= regOutputs(5) when decodeHash(5) = '1' else (others => 'Z');
regDataOut <= regOutputs(6) when decodeHash(6) = '1' else (others => 'Z');
regDataOut <= regOutputs(7) when decodeHash(7) = '1' else (others => 'Z');
regDataOut <= regOutputs(8) when decodeHash(8) = '1' else (others => 'Z');
regDataOut <= regOutputs(9) when decodeHash(9) = '1' else (others => 'Z');
regDataOut <= regOutputs(10) when decodeHash(10) = '1' else (others => 'Z');
regDataOut <= regOutputs(11) when decodeHash(11) = '1' else (others => 'Z');
regDataOut <= regOutputs(12) when decodeHash(12) = '1' else (others => 'Z');
regDataOut <= regOutputs(13) when decodeHash(13) = '1' else (others => 'Z');
regDataOut <= regOutputs(14) when decodeHash(14) = '1' else (others => 'Z');
regDataOut <= regOutputs(15) when decodeHash(15) = '1' else (others => 'Z');
regDataOut <= regOutputs(16) when decodeHash(16) = '1' else (others => 'Z');
regDataOut <= regOutputs(17) when decodeHash(17) = '1' else (others => 'Z');
regDataOut <= regOutputs(18) when decodeHash(18) = '1' else (others => 'Z');
regDataOut <= regOutputs(19) when decodeHash(19) = '1' else (others => 'Z');
regDataOut <= regOutputs(20) when decodeHash(20) = '1' else (others => 'Z');
regDataOut <= regOutputs(21) when decodeHash(21) = '1' else (others => 'Z');
regDataOut <= regOutputs(22) when decodeHash(22) = '1' else (others => 'Z');
regDataOut <= regOutputs(23) when decodeHash(23) = '1' else (others => 'Z');
regDataOut <= regOutputs(24) when decodeHash(24) = '1' else (others => 'Z');
regDataOut <= regOutputs(25) when decodeHash(25) = '1' else (others => 'Z');
regDataOut <= regOutputs(26) when decodeHash(26) = '1' else (others => 'Z');
regDataOut <= regOutputs(27) when decodeHash(27) = '1' else (others => 'Z');
regDataOut <= regOutputs(28) when decodeHash(28) = '1' else (others => 'Z');
regDataOut <= regOutputs(29) when decodeHash(29) = '1' else (others => 'Z');
regDataOut <= regOutputs(30) when decodeHash(30) = '1' else (others => 'Z');
regDataOut <= regOutputs(31) when decodeHash(31) = '1' else (others => 'Z');
regDataOut <= regOutputs(32) when decodeHash(32) = '1' else (others => 'Z');
regDataOut <= regOutputs(33) when decodeHash(33) = '1' else (others => 'Z');
regDataOut <= regOutputs(34) when decodeHash(34) = '1' else (others => 'Z');
regDataOut <= regOutputs(35) when decodeHash(35) = '1' else (others => 'Z');
regDataOut <= regOutputs(36) when decodeHash(36) = '1' else (others => 'Z');
regDataOut <= regOutputs(37) when decodeHash(37) = '1' else (others => 'Z');
regDataOut <= regOutputs(38) when decodeHash(38) = '1' else (others => 'Z');
regDataOut <= regOutputs(39) when decodeHash(39) = '1' else (others => 'Z');
regDataOut <= regOutputs(40) when decodeHash(40) = '1' else (others => 'Z');
regDataOut <= regOutputs(41) when decodeHash(41) = '1' else (others => 'Z');
regDataOut <= regOutputs(42) when decodeHash(42) = '1' else (others => 'Z');
regDataOut <= regOutputs(43) when decodeHash(43) = '1' else (others => 'Z');
regDataOut <= regOutputs(44) when decodeHash(44) = '1' else (others => 'Z');
regDataOut <= regOutputs(45) when decodeHash(45) = '1' else (others => 'Z');
regDataOut <= regOutputs(46) when decodeHash(46) = '1' else (others => 'Z');
regDataOut <= regOutputs(47) when decodeHash(47) = '1' else (others => 'Z');
regDataOut <= regOutputs(48) when decodeHash(48) = '1' else (others => 'Z');
regDataOut <= regOutputs(49) when decodeHash(49) = '1' else (others => 'Z');
regDataOut <= regOutputs(50) when decodeHash(50) = '1' else (others => 'Z');
regDataOut <= regOutputs(51) when decodeHash(51) = '1' else (others => 'Z');
regDataOut <= regOutputs(52) when decodeHash(52) = '1' else (others => 'Z');
regDataOut <= regOutputs(53) when decodeHash(53) = '1' else (others => 'Z');
regDataOut <= regOutputs(54) when decodeHash(54) = '1' else (others => 'Z');
regDataOut <= regOutputs(55) when decodeHash(55) = '1' else (others => 'Z');
regDataOut <= regOutputs(56) when decodeHash(56) = '1' else (others => 'Z');
regDataOut <= regOutputs(57) when decodeHash(57) = '1' else (others => 'Z');
regDataOut <= regOutputs(58) when decodeHash(58) = '1' else (others => 'Z');
regDataOut <= regOutputs(59) when decodeHash(59) = '1' else (others => 'Z');
regDataOut <= regOutputs(60) when decodeHash(60) = '1' else (others => 'Z');
regDataOut <= regOutputs(61) when decodeHash(61) = '1' else (others => 'Z');
regDataOut <= regOutputs(62) when decodeHash(62) = '1' else (others => 'Z');
regDataOut <= regOutputs(63) when decodeHash(63) = '1' else (others => 'Z');
	
	readDecoder: decoder_6to64 port map(DATA_IN => reg_select_read,
                                      DATA_OUT => decodeHash,
                                      EN => '1');

  writeDecoder: decoder_6to64 port map(DATA_IN => reg_select_write,
                                       DATA_OUT => decodeWrite,
                                       EN => '1');
  
	
		GEN_REGS:
		for I in 0 to 63 generate
		begin
			REGX: agingReg port map (
        regEntry => DATA_IN,
        clk_sig => clk_sig2,
        clr => clrn_sig2,
        ena_sig => ena_sig2 and decodeWrite(I),
        prn_sig => prn_sig2,
        qOut => regOutputs(I));
		end generate GEN_REGS;
		
end architecture imp_agingRegFile;
