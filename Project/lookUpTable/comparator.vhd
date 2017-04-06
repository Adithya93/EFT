library ieee;
use ieee.std_logic_1164.all;
library altera; 
use altera.altera_primitives_components.all;

entity comparator is
		port(
			clk, reset:	in std_logic;
			da: 		in std_logic_vector(47 downto 0);
			addr1:	in std_logic_vector(47 downto 0);
			addr2:	in std_logic_vector(47 downto 0);
			compResult:	out std_logic_vector(1 downto 0);
			compDone:	out std_logic;
			compStart: 	in std_logic);
--			comp_state_num:	buffer std_logic_vector(1 downto 0));
end comparator;

architecture comparator_arch of comparator is

type state_type is
			(A, B, C);
signal state_reg, state_next: state_type;

--signal changed : std_logic;
signal comp_state_num:		std_logic_vector(1 downto 0);

begin

process(clk, reset)
	begin
		if(reset = '1') then state_reg <= A;
		elsif (clk'event and clk = '1') then 
			state_reg <= state_next;
		end if;
end process;




process(state_reg, compStart, da, addr1, addr2, compStart)
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
			comp_state_num <= "00";
--			changed <= '0';
		when B =>
--			if (changed = '0') then
				if (da = addr1) then
					compResult(1) <= '1';
				else
					compResult(1) <= '0';
				end if;
				if (da = addr2) then
					compResult(0) <= '1';
				else
					compResult(0) <= '0';
				end if;
--				changed <= '1';
				state_next <= C;
				compDone <= '1';
				comp_state_num <= "01";
--			end if;
		when C => -- just latch compDone and compResult for 1 more cycle
			state_next <= A;
			comp_state_num <= "10";
	end case;
end process;
	
end comparator_arch;