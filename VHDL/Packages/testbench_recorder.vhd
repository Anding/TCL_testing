library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

-- package declaration
package testbench_recorder is
	constant MAX_RESULTS : natural := 1024;
	constant STR_LEN     : natural := 128;

	subtype fixed_string is string(1 to STR_LEN);
	type string_array is array (0 to MAX_RESULTS - 1) of fixed_string;

	type testbench_recorder_protected is protected
	
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
    		report " Recording clock cycles: " & integer'image(testbench_recording'length) & "\n" &
    				 " Reference clock cycles: " & integer'image(testbench_reference'length)
    		severity failure;
    	for i in 0 to testbench_reference'length loop
    		assert testbench_recording(i) = testbench_reference(i)
    			report "Clock cycle: " & natural'image(i) & "\n" &
    					 "Recording: " & testbench_recording(i) & "\n" &
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
		for i in testbench_reference'range loop
			readline(in_file, L);
			read(L, temp_string);
			testbench_reference(i) := temp_string;
		end loop;
	end procedure;

	end protected body;

end package body;

