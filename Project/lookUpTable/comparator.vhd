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
			--compResult:	out std_logic_vector(1 downto 0);
			--compDone:	out std_logic;
			compIdent:	out std_logic_vector(1 downto 0);
			compFinished: out std_logic;
			compStart: 	in std_logic);
			--state_num:	buffer std_logic_vector(1 downto 0));
end comparator;

architecture comparator_arch of comparator is

type state_type is
			(A, B, C);
signal state_reg, state_next: state_type;
signal not_clrn_sig, not_prn_sig: std_logic;
signal compLatch_ena, compLatch_out: std_logic;
signal compResult0, compResult1: std_logic;
signal compDone: std_logic;
signal compResult: std_logic_vector(1 downto 0);

COMPONENT DFFE
   PORT (d   : IN STD_LOGIC;

        clk  : IN STD_LOGIC;

        clrn : IN STD_LOGIC;

        prn  : IN STD_LOGIC;

        ena  : IN STD_LOGIC;

        q    : OUT STD_LOGIC );
	 end component;


begin
	not_clrn_sig <= not reset_sig;
	not_prn_sig <= '1';

	compDoneLatch: DFFE port map
			(d => compDone, clk => clk_sig, clrn => not_clrn_sig, prn => not_prn_sig, ena => compLatch_ena, q => compLatch_out);

	compResultLatch0: DFFE port map
			(d => compResult(0), clk => clk_sig, clrn => not_clrn_sig, prn => not_prn_sig, ena => compLatch_ena, q => compResult0);

	compResultLatch1: DFFE port map
		(d => compResult(1), clk => clk_sig, clrn => not_clrn_sig, prn => not_prn_sig, ena => compLatch_ena, q => compResult1);
		
	compIdent <= compResult;
	compFinished <= compDone;
			
process(clk_sig, reset_sig)
	begin
		if(reset_sig = '1') then state_reg <= A;
		elsif (clk_sig'event and clk_sig = '1') then 
			state_reg <= state_next;
		end if;
end process;


process(state_reg, da, addr1, addr2, compStart, compLatch_out, compResult0, compResult1)
	begin
	compResult <= "00";
	compDone <= '0';
	case state_reg is
		when A =>
			if (compStart = '1') then
				state_next <= B;
			else
				state_next <= A;
			end if;
			compDone <= '0';
			compResult <= "00";
			--state_num <= "00";
			compLatch_ena <= '1';
		when B =>
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
			state_next <= C;
			compDone <= '1';
			compLatch_ena <= '1';
			--state_num <= "01";
		when C => -- just latch compDone and compResult for 1 more cycle
			state_next <= A;
			--state_num <= "10";
			compDone <= compLatch_out;
			compResult(0) <= compResult0;
			compResult(1) <= compResult1;
			compLatch_ena <= '0';
	end case;
end process;
	
end comparator_arch;