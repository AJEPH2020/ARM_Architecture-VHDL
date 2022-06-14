library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Flags is
    port( clk: in std_logic;
        setFlags: in std_logic;
        inC, inV, inZ, inN: in std_logic;
        outC, outV, outZ, outN: out std_logic
    );
end entity Flags;

architecture bev of Flags is

    signal C, V, Z, N: std_logic;

begin
process (clk)
    begin
        if (RISING_EDGE(clk)) then
            if (setFlags = '1') then
                C <= inC;
                V <= inV;
                Z <= inZ;
                N <= inN;
            end if;
        end if;
        outC  <= C;
        outV  <= V;
        outZ  <= Z;
        outN  <= N;
    end process;
end architecture bev;
