library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY RegisterFile IS
PORT(
    Write1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Data: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    WriteOn: IN STD_LOGIC;
    Read1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Read2: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    clk: IN STD_LOGIC;
    out1: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    out2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end ENTITY;

    
ARCHITECTURE Behavioral OF RegisterFile IS
TYPE Reg IS ARRAY(0 to 15) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Mem : Reg;

begin
process(clk)
begin
	IF(RISING_EDGE(clk)) THEN
		IF(WriteOn='1') THEN 
            Mem(CONV_INTEGER(Write1))<=Data;
    	end IF;
    end IF;
    out1<=Mem(CONV_INTEGER(Read1));
    out2<=Mem(CONV_INTEGER(Read2));

end process;
end Behavioral;
