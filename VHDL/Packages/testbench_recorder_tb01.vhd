library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

library work;
-- use the package
use work.testbench_recorder.all;

entity textbench_recorder_tb01 is
end entity;
	
architecture sim of textbench_recorder_tb01 is
constant clock_period : time := 10 ns;
constant half_clock_period : time := clock_period / 2;
	
signal clk : std_logic := '1' ;
signal test_ok : boolean := false;

-- prepare to access the protected type, in an analagous way to a C++ class
shared variable tb_rec : testbench_recorder_protected ;

begin
	
clk <= not clk after half_clock_period;
	
sequencer: process is

begin
	
	wait for clock_period; 
		tb_rec.make_record("one");
	wait for clock_period; 
		tb_rec.make_record("two");		
	wait for clock_period; 
		tb_rec.make_record("three");		
	
	wait for 2 * clock_period;
		tb_rec.save_recording("E:\coding\TCL_testing\VHDL\Packages\testbench_recorder_tb01.log");
			
	report ("*** TEST COMPLETED OK ***");
	test_ok <= true; 
	wait for clock_period;
	std.env.finish;
	
end process;

end architecture;
	
