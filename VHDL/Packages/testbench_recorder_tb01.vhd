library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

-- use the package
library work;
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
		-- save a string record with each clock cycle, likely by converting key signals to strings
		tb_rec.make_record("one");
	wait for clock_period; 
		tb_rec.make_record("two");		
	wait for clock_period; 
		tb_rec.make_record("three");		
	
	wait for 2 * clock_period;
		-- save a known-good run of the DUT to a reference file
		tb_rec.save_recording("E:\coding\TCL_testing\VHDL\Packages\testbench_recorder_tb01_log00.txt");
		-- load a previously recorded known-good reference run
		tb_rec.load_reference_recording("E:\coding\TCL_testing\VHDL\Packages\testbench_recorder_tb01_log01.txt");	
		-- compare the present recording to the reference
		tb_rec.verify_recording_to_reference;		-- log01 passes
		tb_rec.load_reference_recording("E:\coding\TCL_testing\VHDL\Packages\testbench_recorder_tb01_log02.txt");	
		tb_rec.verify_recording_to_reference;		-- log02 fails, the testbench fails here and reports a difference in the logs	in the console			
	report ("*** TEST COMPLETED OK ***");			-- never reached in this testbench
	test_ok <= true; 
	wait for clock_period;
	std.env.finish;
	
end process;

end architecture;
	
