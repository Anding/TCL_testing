library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_alu is 
	generic (
		width : integer := 32
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		opcode : in std_logic_vector(1 downto 0); -- "00" nop, "01" add, "10" unsigned sub, "11" signed sub
		op_A : in std_logic_vector(width - 1 downto 0);
		op_B : in std_logic_vector(width - 1 downto 0);
		result : out std_logic_vector(width - 1 downto 0);
		equalQ : out std_logic
	);
	
end entity;
	
architecture rtl of simple_alu is
		
	signal A_u, B_u : unsigned(width - 1 downto 0);
	signal A_s, B_s : signed(width - 1 downto 0);
	signal result_r : std_logic_vector(width - 1 downto 0);
	signal equalQ_r : std_logic;
	
begin

register_inputs: process is
begin
	wait until rising_edge(clk);
	A_u <= unsigned(op_A);
	B_u <= unsigned(op_B);
	A_s <= signed(op_A);
	B_s <= signed(op_B);
		
end process;
	
register_outputs: process is
begin
	wait until rising_edge(clk);
	if rst = '1' then
		result_r <= (others=>'0');
		equalQ_r <= '0';
	else
		case opcode is
			when "00" =>
				result_r <= (others=>'0');
			when "01" =>
				result_r <= std_logic_vector(A_u + B_u);
			when "10" =>
				result_r <= std_logic_vector(A_u - B_u);
			when others =>  -- ""11"
				result_r <= std_logic_vector(A_s - B_s);
		end case;
		if (A_u = B_u) then
			equalQ_r <= '1';
		else
			equalQ_r <= '0';
		end if;			
	end if;

end process;
	
result <= result_r;
equalQ <= equalQ_r;

end architecture;
	
	