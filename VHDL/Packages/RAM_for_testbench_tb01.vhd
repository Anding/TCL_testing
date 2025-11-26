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
signal test_ended : boolean := false;
signal test_ok : boolean := false;

constant data_width : integer := 32;
constant addr_width : integer := 8;
signal addr_a, addr_b : std_logic_vector( addr_width -1 downto 0 ) := (others =>'0');
signal mem_data_to_RAM_a, mem_data_to_RAM_b : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal mem_data_from_RAM_a, mem_data_from_RAM_b : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal we_a, we_b : std_logic := '0';

-- prepare to access the protected type, in an analagous way to a C++ class
shared variable bram_inst : work.bram.RAM_for_testbench_class ;
shared variable tb_rec_inst : work.testbench_recorder.testbench_recorder_protected ;
begin
	
clk <= not clk after half_clock_period;

memory: process is
begin	
	wait until rising_edge(clk);
	-- bram is a new package created out of the generic package
	-- 	file RAM_for_testbench_tb01_lib.vhd
	bram_inst.memory_port(addr_a, mem_data_to_RAM_a, mem_data_from_RAM_a, we_a);
	bram_inst.memory_port(addr_b, mem_data_to_RAM_b, mem_data_from_RAM_b, we_b);		
end process;

recorder: process is
begin
	wait until rising_edge(clk);
	if (test_ended) then
		-- either save or verify
		--	tb_rec_inst.save_recording("E:\coding\TCL_testing\VHDL\Packages\RAM_for_testbench_tb01_log.txt");
	      tb_rec_inst.load_reference_recording("E:\coding\TCL_testing\VHDL\Packages\RAM_for_testbench_tb01_log.txt");
			tb_rec_inst.verify_recording_to_reference;
	else
			tb_rec_inst.make_record(
				"addr_a = " & to_hstring(addr_a) & ", " &
				"mem_data_from_RAM_a = " & to_hstring(mem_data_from_RAM_a) & ", " &
				"addr_b = " & to_hstring(addr_b) & ", " &
				"mem_data_from_RAM_b = " & to_hstring(mem_data_from_RAM_b)
			);
	end if;
end process;	

sequencer: process is

begin
	
	wait for clock_period;
				
	wait for 2 * clock_period;
	
	addr_a <= X"01";
	mem_data_to_RAM_a <= X"0A0B0C0D";
	we_a <= '1';
	wait for clock_period;
	
	mem_data_to_RAM_a <= X"00000000";	
	we_a <= '0';
	addr_b <= x"01";
	wait for clock_period;
	
	addr_b <= X"01";
	mem_data_to_RAM_b <= X"12345678";
	we_b <= '1';
	wait for clock_period;	
	
	mem_data_to_RAM_b <= X"ABCDABCD";	
	we_b <= '1';
	addr_b <= x"02";
	wait for clock_period;	
	
	mem_data_to_RAM_b <= X"00000000";	
	we_b <= '0';
	addr_b <= x"01";
	addr_a <= x"01";
	wait for clock_period;		
	
	wait for 4 * clock_period;		
		
	test_ended <= true;	wait for clock_period;
	-- save or verify the testbench recording
	test_ok <= true;	wait for clock_period; 
	report ("*** TEST COMPLETED OK ***");		
	std.env.finish;
	
end process;

end architecture;