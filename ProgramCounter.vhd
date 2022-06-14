library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity programCounter is
    port( clk: in std_logic;
        PC_Start: in std_logic_vector(31 downto 0);
        rset: in std_logic;
        move: in std_logic;
        branchOffset: in std_logic_vector(23 downto 0);
        pcOut: out std_logic_vector(31 downto 0)
        );
end entity programCounter;

architecture pc_update of programCounter is

    signal PC_current: std_logic_vector(31 downto 0);

begin
process (clk,rset,move)
    begin
        if (RISING_EDGE(clk)) then
            if (rset = '1') then
                PC_current <= PC_Start;
            elsif (rset = '0') then
                if (move = '1') then
                    PC_current <= PC_current + branchOffset + "1";
                end if;
            end if;
        end if;
        pcOut <= PC_current;
    end process;
end architecture pc_update;
