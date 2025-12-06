library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- use the package
library work;

entity RAM_for_testbench_tb02 is
end entity;
	
architecture sim of RAM_for_testbench_tb02 is
constant clock_period : time := 10 ns;
constant half_clock_period : time := clock_period / 2;
signal clk : std_logic := '1' ;
signal test_ending, test_starting : boolean := false;
signal test_ok : boolean := false;

constant data_width : integer := work.RAM_for_testbench_tb02_pck.DATA_WIDTH;
constant addr_width : integer := work.RAM_for_testbench_tb02_pck.ADDR_WIDTH;
signal addr_a : std_logic_vector( addr_width -1 downto 0 ) := (others =>'0');
signal mem_data_to_RAM_a : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal mem_data_from_RAM_a : std_logic_vector( data_width -1 downto 0 ) := (others =>'0');
signal we_a : std_logic := '0';

-- prepare to access the protected type, in an analagous way to a C++ class
shared variable bram_inst : work.RAM_for_testbench_tb02_pck.RAM_for_testbench_class ;
begin
	
clk <= not clk after half_clock_period;

memory: process is
begin	
	wait until rising_edge(clk);
	-- bram is a new package created out of the generic package
	bram_inst.memory_port(addr_a, mem_data_to_RAM_a, mem_data_from_RAM_a, we_a);
end process;

recorder: process is
begin
	wait until rising_edge(clk);
	if (test_starting) then
		bram_inst.load_RAM("E:\coding\TCL_testing\VHDL\Packages\RAM_for_testbench_tb02_RAM.txt");
	end if;
	if (test_ending) then
		-- either save or verify
		bram_inst.save_RAM("E:\coding\TCL_testing\VHDL\Packages\RAM_for_testbench_tb02_RAM.txt");
		--	bram_inst.verify_RAM("E:\coding\TCL_testing\VHDL\Packages\RAM_for_testbench_tb02_RAM.txt");;
	end if;
end process;	

sequencer: process is

begin
	
	wait for clock_period;
	test_starting <= true;	wait for clock_period; test_starting <= false; 
	
	wait for clock_period;
	
	wait for 4 * clock_period;		
		
	test_ending <= true;	wait for clock_period; test_ending <= false;
	-- save or verify the testbench recording
	test_ok <= true;	wait for clock_period; 
	report ("*** TEST COMPLETED OK ***");		
	std.env.finish;
	
end process;

end architecture;