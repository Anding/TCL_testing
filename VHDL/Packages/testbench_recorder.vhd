-- TESTBENCH_RECORDER is a reusable package for recording and verifying testbench runs
-- Andrew Read, October 2025

-- relevant signals are converted to strings and passed to make_record
-- save_recording can be used to keep the recording of a known-good run of the DUT
-- load_reference_recording and verify_recording_to_reference can be used to compare subsequent testbench runs to the know-good one
-- the file format is plain text so the log files are easy to review
-- see textbench_recorder_tb01.vhd for the use example
-- Vivado file properties MUST BE SET to VHDL2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- package declaration
package testbench_recorder is
	constant MAX_RESULTS : natural := 1024;			-- maxmium number of records per file (all files have this many records)
	constant STR_LEN     : natural := 128;				-- maximum record length (each line of the file is this length, padded with ASCII 32)
																	-- each log file is 128kiB in size
	subtype fixed_string is string(1 to STR_LEN);
	type string_array is array (0 to MAX_RESULTS -1) of fixed_string;

	type testbench_recorder_protected is protected	-- use a protected type 
	
	procedure make_record (record_string : in string); 
		-- call this at every clock cycle with a string represention of critical signals; no need for initialization
	procedure save_recording ( filename : in string);		
		-- call this after a known-good testbench run to save the recording
	procedure load_reference_recording ( filename : in string);
		-- call this before subsequent testbench runs to load the recording of the known-good run
	procedure verify_recording_to_reference;	
		-- call at the end of the run to ASSERT for differences between the last recording and the known-good run		
	end protected;

end package;

-- package body
package body testbench_recorder is
	type testbench_recorder_protected is protected body
	
	variable index : natural := 0;
	variable testbench_recording : string_array := (others => (others => ' '));
	variable testbench_reference : string_array := (others => (others => ' '));		

	procedure make_record (record_string : in string)  is
	begin
		testbench_recording(index)(1 to record_string'length) := record_string;
		index := index + 1;
    end procedure;
    
    procedure verify_recording_to_reference is
    begin
    	assert testbench_recording'length = testbench_reference'length
    		report " Recording lines: " & integer'image(testbench_recording'length) & character'VAL(10) &
    				 " Reference lines: " & integer'image(testbench_reference'length)
    		severity failure;
    	for i in 0 to testbench_reference'length - 1 loop
    		assert testbench_recording(i) = testbench_reference(i)
    			report "Difference at line " & natural'image(i+1) & character'VAL(10) &
    					 "Recording: " & testbench_recording(i) & character'VAL(10) &
    					 "Reference: " & testbench_reference(i)
    			severity failure;
    	end loop;
    end procedure;
    
	procedure save_recording ( filename : in string) is
		file out_file : text open write_mode is filename;
		variable L : line;
	begin
		for i in testbench_recording'range loop
    		write(L, testbench_recording(i));
    		writeline(out_file, L);
  		end loop;  	
	end procedure;
	
	procedure load_reference_recording ( filename : in string) is
		file in_file : text open read_mode is filename;
  		variable L : line;
  		variable temp_string : fixed_string;
	begin
		testbench_reference := (others => (others => ' '));
		for i in testbench_reference'range loop
			readline(in_file, L);
			read(L, temp_string);
			testbench_reference(i) := temp_string;
		end loop;
	end procedure;

	end protected body;

end package body;

