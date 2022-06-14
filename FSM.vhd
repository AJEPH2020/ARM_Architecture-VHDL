library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm is
    port(
        inA, inB, inIR, inDR, inRES: in std_logic_vector(31 downto 0);
        fsminput: in std_logic_vector(3 downto 0);
        fsmoutput: out std_logic_vector(3 downto 0);
        outA, outB, outIR, outDR, outRES: out std_logic_vector(31 downto 0)
        );
end entity fsm;

architecture bev of fsm is

    signal fsm_current: std_logic_vector(3 downto 0);

    signal A, B, IR, DR, RES: std_logic_vector(31 downto 0);

begin
process(fsminput)
begin

    case(fsminput) is
    when "0001" =>

        fsm_current <= "0010";

  
    when "0010" =>

        if (IR(27 downto 26) = "00") then

            if (IR(27 downto 25) = "000" and IR(7) = '1' and IR(4) = '1') then

            
                fsm_current <= "0100";
    
            else
    
                fsm_current <= "0011";
    
            end if;

        elsif (IR(27 downto 26) = "01") then

            fsm_current <= "0100";

        elsif (IR(27 downto 26) = "10") then

            fsm_current <= "0101";

        end if;

  
    when "0011" =>

        fsm_current <= "0110";
      
  
    when "0100" =>

        if (IR(20) = '0') then

            fsm_current <= "0111";

        elsif (IR(20) = '1') then

            fsm_current <= "1000";

        end if;

  
    when "0101" =>

        fsm_current <= "0001";


    when "0110" =>

        fsm_current <= "0001";
        

    when "0111" =>

        fsm_current <= "0001";

      
    when "1000" =>

        fsm_current <= "1001";


    when "1001" =>

        fsm_current <= "0001";
  

    when others => 

        fsm_current <= "0001";

    
   end case;
  
end process;

fsmoutput <= fsm_current;


process (inA)
begin
    A <= inA;
end process;
outA <= A;


process (inB)
begin
    B <= inB;
end process;
outB <= B;


process (inIR)
begin
    IR <= inIR;   
end process;
outIR <= IR;


process (inDR)
begin
    DR <= inDR;
end process;
outDR <= DR;


process (inRES)
begin
    RES <= inRES;
end process;
outRES <= RES;



end architecture bev;
