library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- use the package
library work;

entity RAM_for_testbench_tb01 is
end entity;
	
architecture sim of RAM_for_testbench_tb01 is
constant clock_period : time := 10 ns;
constant half_clock_period : time := clock_period / 2;
signal clk : std_logic := '1' ;
signal test_ok : boolean := false;

constant data_width : integer := 32;
constant addr_width : integer := 8;
signal addr_a, addr_b : std_logic_vector( addr_width -1 downto 0 ) := (others =>'0');
signal mem_data_to_RAM_a, mem_data_to_RAM_b : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal mem_data_from_RAM_a, mem_data_from_RAM_b : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal we_a, we_b : std_logic := '0';

-- prepare to access the protected type, in an analagous way to a C++ class
shared variable bram_class : work.bram.RAM_for_testbench_protected ;

begin
	
clk <= not clk after half_clock_period;

memory: process is
begin	
	wait until rising_edge(clk);
	-- bram is a new package created out of the generic package
	-- 	file RAM_for_testbench_tb01_lib.vhd
	bram_class.memory_port(addr_a, mem_data_to_RAM_a, mem_data_from_RAM_a, we_a);
	bram_class.memory_port(addr_b, mem_data_to_RAM_b, mem_data_from_RAM_b, we_b);		
end process;

sequencer: process is

begin
	
	wait for clock_period;
				
	wait for 2 * clock_period;

	report ("*** TEST COMPLETED OK ***");
	test_ok <= true; 
	wait for clock_period;
	std.env.finish;
	
end process;

end architecture;