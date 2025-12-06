library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

-- create a new package out of the generic package
package RAM_for_testbench_tb02_pck is new work.RAM_for_testbench
  generic map (
    DATA_WIDTH => 8,
    ADDR_WIDTH => 8
  );