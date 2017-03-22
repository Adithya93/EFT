library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_5to32 is
    Port ( DATA_IN  : in  STD_LOGIC_VECTOR (4 downto 0);  -- 5-bit input
           DATA_OUT  : out STD_LOGIC_VECTOR (31 downto 0);  -- 32-bit output
           EN : in  STD_LOGIC);                     -- enable input
end decoder_5to32;

architecture impl of decoder_5to32 is
begin
process (DATA_IN, EN)
begin
    DATA_OUT <= (others => '0');        -- default output value
    if (EN = '1') then  -- active high enable pin
        case DATA_IN is
            when "00000" => DATA_OUT(0) <= '1';
				when "00001" => DATA_OUT(1) <= '1';
            when "00010" => DATA_OUT(2) <= '1';
            when "00011" => DATA_OUT(3) <= '1';
            when "00100" => DATA_OUT(4) <= '1';
            when "00101" => DATA_OUT(5) <= '1';
            when "00110" => DATA_OUT(6) <= '1';
            when "00111" => DATA_OUT(7) <= '1';
            when "01000" => DATA_OUT(8) <= '1';
            when "01001" => DATA_OUT(9) <= '1';
            when "01010" => DATA_OUT(10) <= '1';
            when "01011" => DATA_OUT(11) <= '1';
            when "01100" => DATA_OUT(12) <= '1';
            when "01101" => DATA_OUT(13) <= '1';
            when "01110" => DATA_OUT(14) <= '1';
            when "01111" => DATA_OUT(15) <= '1';
            when "10000" => DATA_OUT(16) <= '1';
            when "10001" => DATA_OUT(17) <= '1';
            when "10010" => DATA_OUT(18) <= '1';
            when "10011" => DATA_OUT(19) <= '1';
            when "10100" => DATA_OUT(20) <= '1';
            when "10101" => DATA_OUT(21) <= '1';
            when "10110" => DATA_OUT(22) <= '1';
            when "10111" => DATA_OUT(23) <= '1';
            when "11000" => DATA_OUT(24) <= '1';
            when "11001" => DATA_OUT(25) <= '1';
            when "11010" => DATA_OUT(26) <= '1';
            when "11011" => DATA_OUT(27) <= '1';
            when "11100" => DATA_OUT(28) <= '1';
            when "11101" => DATA_OUT(29) <= '1';
            when "11110" => DATA_OUT(30) <= '1';
            when "11111" => DATA_OUT(31) <= '1';
				when others => DATA_OUT <= (others => '0');
        end case;
    end if;
end process;
end impl;