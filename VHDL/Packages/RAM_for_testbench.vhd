-- RAM_FOR_TESTBENCH is a reusable package for simulating BLOCK RAM in a test bench
-- Andrew Read, November 2025

-- Vivado file properties MUST BE SET to VHDL2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;

-- package declaration
package RAM_for_testbench is
  generic (
    DATA_WIDTH : positive := 32;
    ADDR_WIDTH : positive := 8
  );
  
	constant DEPTH : natural := 2**ADDR_WIDTH;
	subtype addr_type	is std_logic_vector(ADDR_WIDTH - 1 downto 0);
	subtype data_type is std_logic_vector(DATA_WIDTH - 1 downto 0);
	type memory_type	is array (0 to DEPTH - 1) of data_type;
	shared variable memory : memory_type := (others => (others => '0'));
					
	--type RAM_for_testbench_protected is protected	-- use a protected type 
	  	
	procedure memory_port(
		addr : in addr_type;
	  	mem_data_to_RAM : in data_type;
	  	signal mem_data_from_RAM : out data_type;
	  	we : in std_logic);
	
	--end protected;

end package;

package body RAM_for_testbench is
	--type RAM_for_testbench_protected is protected body
	
	procedure memory_port(
		addr : in addr_type;
	  	mem_data_to_RAM : in data_type;
	  	signal mem_data_from_RAM : out data_type;
	  	we : in std_logic) is
	variable addr_i : integer;
	begin
		addr_i := to_integer(unsigned(addr));
	  	if we = '1' then 
	  		memory (addr_i) := mem_data_to_RAM;
	  	end if;
	  	mem_data_from_RAM <= memory(addr_i);
	 end procedure;
	
	--end protected body;
end package body;

package bram is new work.RAM_for_testbench
  generic map (
    DATA_WIDTH => 32,
    ADDR_WIDTH => 8
  );