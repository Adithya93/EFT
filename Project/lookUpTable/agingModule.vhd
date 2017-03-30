library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity agingModule is
  port (
    clk, global_reset: in std_logic;
    look_now: in std_logic;
    set_reg_age: in std_logic_vector(5 downto 0);
    age_out_now: out std_logic;
    age_out_reg: out std_logic_vector(5 downto 0);
    glob_timer: out std_logic_vector(34 downto 0)
    );
end agingModule;

architecture agingmod_arch of agingModule is

  signal read_age : std_logic_vector(5 downto 0);
  signal get_time : std_logic_vector(8 downto 0);
  signal timer_clear : std_logic;
  signal global_timer : std_logic_vector(34 downto 0);
  signal reg_counter_clr : std_logic;
  signal count_regs : std_logic;
  
  type state_type is (s0,s1,s2,s3);
  signal state_reg, state_next: state_type;

  component agingRegFile
    PORT(
      DATA_IN: in std_logic_vector(8 downto 0);
      reg_select_write: in std_logic_vector(5 downto 0);
      reg_select_read: in std_logic_vector(5 downto 0);
      clk_sig2,clrn_sig2,ena_sig2,prn_sig2 : in std_logic;
      regDataOut: out std_logic_vector(8 downto 0)
      );
  end component;

  component agingTimer
    PORT(
      clk,clr,count: in std_logic;
      Q : out std_logic_vector(34 downto 0)
      );
  end component;

  component regCounter
    port (
      clk,clr,count : in std_logic;
      Q : out std_logic_vector(5 downto 0)
      );
  end component;
  
        
begin
  age_out_reg <= read_age;
  glob_timer <= global_timer;

  ageTime : agingTimer port map (
    clk => clk,
    clr => timer_clear,
    count => '1',
    Q => global_timer
    );

  regCount : regCounter port map (
    clk => clk,
    clr => reg_counter_clr,
    count => count_regs,
    Q => read_age
    );


  agingRegisters : agingRegFile port map (
    DATA_IN => global_timer(34 downto 26),
    reg_select_write => set_reg_age,
    reg_select_read => read_age,
    clk_sig2 => clk,
    clrn_sig2 => global_reset,
    ena_sig2 => look_now,
    prn_sig2 => '0',
    regDataOut => get_time
    );


  process (clk, global_reset)
  begin
    if (global_reset='1') then state_reg <= s0;
    elsif (clk'event and clk='1') then
     state_reg <= state_next;
    end if;
  end process;

  
  process (state_reg,get_time)
  begin
    case state_reg is
      when s0 => -- reset state
        reg_counter_clr <= '1';
        count_regs <= '0';
        timer_clear <= '1';
        state_next <= s1;
        age_out_now <= '0';
      when s1 => -- global_timer counting state
        reg_counter_clr <= '1';
        count_regs <= '0';
        timer_clear <= '0';
        age_out_now <= '0';
        if (global_timer(24 downto 0)="0000000000000000000000000") then
          state_next <= s2;
        elsif(global_timer(34 downto 0)="1101111110000100011101011000000000") then
          state_next <= s0;   
        else
          state_next <= s1;
        end if;
      when s2 => -- check if registers have aged out
        reg_counter_clr <= '0';
        count_regs <= '1';
        timer_clear <= '0';
        age_out_now <= '0';
        if (read_age = "111111") then
          state_next <= s1;
        else
          if (get_time = global_timer(34 downto 26)-1)then
            state_next <= s3;
          else
            state_next <= s2;
          end if;
        end if;
      when s3 => -- age out register
        reg_counter_clr <= '0';
        count_regs <= '1';
        timer_clear <= '0';
        age_out_now <= '1';
        state_next <= s2;
    end case;
  end process;
  

                    
          
end agingmod_arch;
