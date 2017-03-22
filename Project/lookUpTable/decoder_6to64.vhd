library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_6to64 is
    Port ( DATA_IN  : in  STD_LOGIC_VECTOR (5 downto 0);  -- 6-bit input
           DATA_OUT  : out STD_LOGIC_VECTOR (63 downto 0);  -- 64-bit output
           EN : in  STD_LOGIC);                     -- enable input
end decoder_6to64;

architecture impl of decoder_6to64 is
begin
process (DATA_IN, EN)
begin
    DATA_OUT <= (others => '0');        -- default output value
    if (EN = '1') then  -- active high enable pin
        case DATA_IN is
            
				when "000000" => DATA_OUT(0) <= '1';
				when "000001" => DATA_OUT(1) <= '1';
            when "000010" => DATA_OUT(2) <= '1';
            when "000011" => DATA_OUT(3) <= '1';
            when "000100" => DATA_OUT(4) <= '1';
            when "000101" => DATA_OUT(5) <= '1';
            when "000110" => DATA_OUT(6) <= '1';
            when "000111" => DATA_OUT(7) <= '1';
            when "001000" => DATA_OUT(8) <= '1';
            when "001001" => DATA_OUT(9) <= '1';
            when "001010" => DATA_OUT(10) <= '1';
            when "001011" => DATA_OUT(11) <= '1';
            when "001100" => DATA_OUT(12) <= '1';
            when "001101" => DATA_OUT(13) <= '1';
            when "001110" => DATA_OUT(14) <= '1';
            when "001111" => DATA_OUT(15) <= '1';
            when "010000" => DATA_OUT(16) <= '1';
            when "010001" => DATA_OUT(17) <= '1';
            when "010010" => DATA_OUT(18) <= '1';
            when "010011" => DATA_OUT(19) <= '1';
            when "010100" => DATA_OUT(20) <= '1';
            when "010101" => DATA_OUT(21) <= '1';
            when "010110" => DATA_OUT(22) <= '1';
            when "010111" => DATA_OUT(23) <= '1';
            when "011000" => DATA_OUT(24) <= '1';
            when "011001" => DATA_OUT(25) <= '1';
            when "011010" => DATA_OUT(26) <= '1';
            when "011011" => DATA_OUT(27) <= '1';
            when "011100" => DATA_OUT(28) <= '1';
            when "011101" => DATA_OUT(29) <= '1';
            when "011110" => DATA_OUT(30) <= '1';
            when "011111" => DATA_OUT(31) <= '1';
				
				when "100000" => DATA_OUT(32) <= '1';
				when "100001" => DATA_OUT(33) <= '1';
            when "100010" => DATA_OUT(34) <= '1';
            when "100011" => DATA_OUT(35) <= '1';
            when "100100" => DATA_OUT(36) <= '1';
            when "100101" => DATA_OUT(37) <= '1';
            when "100110" => DATA_OUT(38) <= '1';
            when "100111" => DATA_OUT(39) <= '1';
            when "101000" => DATA_OUT(40) <= '1';
            when "101001" => DATA_OUT(41) <= '1';
            when "101010" => DATA_OUT(42) <= '1';
            when "101011" => DATA_OUT(43) <= '1';
            when "101100" => DATA_OUT(44) <= '1';
            when "101101" => DATA_OUT(45) <= '1';
            when "101110" => DATA_OUT(46) <= '1';
            when "101111" => DATA_OUT(47) <= '1';
            when "110000" => DATA_OUT(48) <= '1';
            when "110001" => DATA_OUT(49) <= '1';
            when "110010" => DATA_OUT(50) <= '1';
            when "110011" => DATA_OUT(51) <= '1';
            when "110100" => DATA_OUT(52) <= '1';
            when "110101" => DATA_OUT(53) <= '1';
            when "110110" => DATA_OUT(54) <= '1';
            when "110111" => DATA_OUT(55) <= '1';
            when "111000" => DATA_OUT(56) <= '1';
            when "111001" => DATA_OUT(57) <= '1';
            when "111010" => DATA_OUT(58) <= '1';
            when "111011" => DATA_OUT(59) <= '1';
            when "111100" => DATA_OUT(60) <= '1';
            when "111101" => DATA_OUT(61) <= '1';
            when "111110" => DATA_OUT(62) <= '1';
            when "111111" => DATA_OUT(63) <= '1';
				
				when others => DATA_OUT <= (others => '0');
        end case;
    end if;
end process;
end impl;