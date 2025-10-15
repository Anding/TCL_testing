library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.ALL;


-- package declaration
package testbench_recorder is
	constant MAX_RESULTS : natural := 1024;
	constant STR_LEN     : natural := 128;

	subtype fixed_string is string(1 to STR_LEN);
	type string_array is array (0 to MAX_RESULTS - 1) of fixed_string;

	protected testbench_recorder_protected is
	
	procedure make_record (record_string : in string) 
	procedure load_reference_recording ( filename : in string);
	procedure save_reference_recording ( filename : in string);
	procedure verify_recording ();
	
	
	private
	
	variable index : natural := 0;
	variable testbench_recording : string_array := (others => (others => ' '));
	variable testbench_reference : string_array := (others => (others => ' '));		
	
	end protected

end package;

-- package body
package body testbench_recorder is
	protected body testbench_recorder_protected is

	procedure make_record (record_string : in string)  is
		begin
			testbench_recording(index)(1 to record_string'length) := record_string;
			index := index + 1;
    end procedure;
    
    procedure verify_recording () is
    begin
    	assert testbench_recording'length = testbench_reference'length
    		report " Recording clock cycles: " & testbench_recording'length & "\n" &
    				 " Reference clock cycles: " & testbench_reference'length
    		severity failure;
    	for i in 0 to testbench_reference'length
    		assert testbench_recording(i) = testbench_reference(i)
    			report "Clock cycle: " & natural'image(i) & "\n" &
    					 "Recording: " & testbench_recording(i) & "\n" &
    					 "Reference: " & testbench_reference(i)
    			severity failure;
    	end loop
    end procedure;

	end protected;

end package body;

