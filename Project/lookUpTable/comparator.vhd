library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity comparator is
		port(
			clk_sig, reset_sig:	in std_logic;
			da: 		in std_logic_vector(47 downto 0);
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic;
			compStart: 	in std_logic;
			state_num:	buffer std_logic_vector(1 downto 0));
end comparator;

architecture comparator_arch of comparator is

type state_type is
			(A, B, C);
signal state_reg, state_next: state_type;

begin

process(clk_sig, reset_sig)
	begin
		if(reset_sig = '1') then state_reg <= A;
		elsif (clk_sig'event and clk_sig = '1') then 
			state_reg <= state_next;
		end if;
end process;


process(state_reg, da, addr1, addr2, compStart)
	begin
	case state_reg is
		when A =>
			if (compStart = '1') then
				state_next <= B;
			else
				state_next <= A;
			end if;
			compDone <= '0';
			compResult <= "00";
			state_num <= "00";
		when B =>
			if (da = addr1) then
				compResult(0) <= '1';
			else
				compResult(0) <= '0';
			end if;
			if (da = addr2) then
				compResult(1) <= '1';
			else
				compResult(1) <= '0';
			end if;
			state_next <= C;
			compDone <= '1';
			state_num <= "01";
		when C => -- just latch compDone and compResult for 1 more cycle
			state_next <= A;
			state_num <= "10";
	end case;
end process;
	
end comparator_arch;