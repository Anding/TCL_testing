library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library test;

entity simple_alu_tb is
end entity;
	
architecture sim of simple_alu_tb is
constant alu_width : integer := 8;
constant clock_freq : natural := 100E6;
constant clock_period : time := 1 sec / clock_freq;
constant half_clock_period : time := clock_period / 2;

signal test_ok : boolean := false;

signal clk : std_logic := '1';
signal rst : std_logic := '1';
signal opcode : std_logic_vector(1 downto 0); -- "00" nop, "01" add, "10" unsigned sub, "11" signed sub
signal op_A : std_logic_vector(alu_width - 1 downto 0) := (others=>'0');
signal op_B : std_logic_vector(alu_width - 1 downto 0) := (others=>'0');
signal result : std_logic_vector(alu_width - 1 downto 0);
signal equalQ : std_logic;

begin
	
DUT: entity test.simple_alu(rtl)
	generic map(
		width => alu_width
	)
	port map(
		clk => clk,
		rst => rst,
		opcode => opcode,
		op_A => op_A,
		op_B => op_B,
		result => result,
		equalQ => equalQ
	);
		
clk <= not clk after half_clock_period;

sequencer_process : process 

begin
	wait for 4 * clock_period;
	wait until rising_edge(clk);
	rst <= '0';
	wait until rising_edge(clk);
		
	op_A <= x"01"; op_B <= x"02"; opcode <= "01";
	wait until rising_edge(clk);				-- DUT registers inputs
	wait until rising_edge(clk);				-- DUT registers outputs
	wait for 1 ps;	assert result = x"03"		-- delta cycle before assert
		report "add failed" severity failure;
	
	op_A <= x"00"; op_B <= x"00"; opcode <= "00";
	wait until rising_edge(clk);				-- DUT registers inputs
	wait until rising_edge(clk);				-- DUT registers outputs
			
	wait for clock_period;
	report ("*** TEST COMPLETED OK ***");
	test_ok <= true; 
	wait for clock_period;
	std.env.finish;

		
end process;
	
end architecture;