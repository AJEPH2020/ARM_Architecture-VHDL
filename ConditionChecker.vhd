library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CondCheck is
    port( ccinZ: in std_logic;
        condition: in std_logic_vector(3 downto 0);
        ccoutput: out std_logic
		);
end entity CondCheck;

architecture bev of CondCheck is

begin
process (condition,ccinZ)
    begin
        if (condition(1) = '1') then
            ccoutput <= '1';
        elsif (condition(0) = '0') then
            ccoutput <= ccinZ;
        elsif (condition(0) = '1') then
            ccoutput <= not(ccinZ);            
        end if;
    end process;
end architecture bev;

