library ieee; 
use ieee.std_logic_1164.all;

entity crc is 
  port ( data_in : in std_logic_vector (15 downto 0);
    crc_en , rst, clk : in std_logic;
    crc_out : out std_logic_vector (4 downto 0));
end crc;

architecture imp_crc of crc is	
  signal lfsr_q: std_logic_vector (4 downto 0);	
  signal lfsr_c: std_logic_vector (4 downto 0);	
begin	
    crc_out <= lfsr_q;

    lfsr_c(0) <= lfsr_q(0) xor lfsr_q(1) xor lfsr_q(2) xor data_in(0) xor data_in(3) xor data_in(5) xor data_in(6) xor data_in(9) xor data_in(10) xor data_in(11) xor data_in(12) xor data_in(13);
    lfsr_c(1) <= lfsr_q(0) xor lfsr_q(1) xor lfsr_q(2) xor lfsr_q(3) xor data_in(1) xor data_in(4) xor data_in(6) xor data_in(7) xor data_in(10) xor data_in(11) xor data_in(12) xor data_in(13) xor data_in(14);
    lfsr_c(2) <= lfsr_q(3) xor lfsr_q(4) xor data_in(0) xor data_in(2) xor data_in(3) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10) xor data_in(14) xor data_in(15);
    lfsr_c(3) <= lfsr_q(0) xor lfsr_q(4) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10) xor data_in(11) xor data_in(15);
    lfsr_c(4) <= lfsr_q(0) xor lfsr_q(1) xor data_in(2) xor data_in(4) xor data_in(5) xor data_in(8) xor data_in(9) xor data_in(10) xor data_in(11) xor data_in(12);


    process (clk,rst) begin 
      if (rst = '1') then 
        lfsr_q <= b"11111";
      elsif (clk'EVENT and clk = '1') then 
        if (crc_en = '1') then 
          lfsr_q <= lfsr_c; 
       	end if; 
      end if; 
    end process; 
end architecture imp_crc; 