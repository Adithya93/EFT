library ieee;
use ieee.std_logic_1164.all;

entity agingModule is
  port (
    clk, global_reset: in std_logic;
    look_now: in std_logic;
    set_reg_age: in std_logic_vector(5 downto 0);
    age_out_now: out std_logic;
    age_out_reg: out std_logic_vector(5 downto 0);
    );
end agingModule;

architecture agingmod_arch of agingModule is
begin

end agingmod_arch;
