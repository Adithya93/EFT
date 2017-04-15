library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity agingTimer is
  port (
    clk, clr, count : in std_logic;
    Q : out std_logic_vector(9 downto 0) -- 34-0
    );
end agingTimer;

architecture behavior of agingTimer is

  signal Pre_Q : std_logic_vector(9 downto 0); -- 34-0

begin
  process(clk,clr,count, Pre_Q)
  begin
    if (clr = '1') then
      Pre_Q <= Pre_Q - Pre_Q;
    elsif (clk'event and clk='1') then
      if (count = '1') then
        Pre_Q <= Pre_Q + 1;
      end if;
    end if;
  end process;

  Q <= Pre_Q;

end behavior;
