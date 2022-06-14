library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pmconnect is
    port( rout: in std_logic_vector(31 downto 0);
        mout: in std_logic_vector(31 downto 0);
        instruction: in std_logic_vector(31 downto 0);
        padrs: in std_logic_vector(1 downto 0);
        sl: in std_logic;
        pmcon: in std_logic;
        rin: out std_logic_vector(31 downto 0);
        min: out std_logic_vector(31 downto 0);
        mw: out std_logic_vector(3 downto 0)
		);
end entity pmconnect;

architecture bev of pmconnect is

begin
process (pmcon)

    variable zero: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    variable  one: std_logic_vector(31 downto 0):="11111111111111111111111111111111";

    variable m: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    variable r: std_logic_vector(31 downto 0):="00000000000000000000000000000000";

    begin


        if (sl = '0') then

            if (instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1') then --strh
                
                if (padrs = "00") then

                    m(15 downto 0) := rout(15 downto 0);
                    m(31 downto 16) := rout(15 downto 0);
                    mw <= "0011";

                elsif (padrs = "10") then

                    m(15 downto 0) := rout(15 downto 0);
                    m(31 downto 16) := rout(15 downto 0);
                    mw <= "1100";

                end if;


            else --str, strb

                if (instruction(22) = '0') then --str

                    m := rout;
                    mw <= "1111";

                else --strb

                    if (padrs = "00") then

                        m(7 downto 0) := rout(7 downto 0);
                        m(15 downto 8) := rout(7 downto 0);
                        m(23 downto 16) := rout(7 downto 0);
                        m(31 downto 24) := rout(7 downto 0);
                        mw <= "0001";

                    elsif (padrs = "01") then

                        m(7 downto 0) := rout(7 downto 0);
                        m(15 downto 8) := rout(7 downto 0);
                        m(23 downto 16) := rout(7 downto 0);
                        m(31 downto 24) := rout(7 downto 0);
                        mw <= "0010";

                    elsif (padrs = "10") then

                        m(7 downto 0) := rout(7 downto 0);
                        m(15 downto 8) := rout(7 downto 0);
                        m(23 downto 16) := rout(7 downto 0);
                        m(31 downto 24) := rout(7 downto 0);
                        mw <= "0100";

                    elsif (padrs = "11") then

                        m(7 downto 0) := rout(7 downto 0);
                        m(15 downto 8) := rout(7 downto 0);
                        m(23 downto 16) := rout(7 downto 0);
                        m(31 downto 24) := rout(7 downto 0);
                        mw <= "1000";

                    end if;

                end if;
                
            end if;

        elsif (sl = '1') then

            if (instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1') then --ldrh, ldrsb, ldrsh
                
                if (instruction(6 downto 5) = "01") then --ldrh

                    if (padrs = "00") then

                        r(15 downto 0) := mout(15 downto 0);

                    elsif (padrs = "10") then

                        r(15 downto 0) := mout(31 downto 16);

                    end if;


                elsif (instruction(6 downto 5) = "10") then --ldrsb

                    if (padrs = "00") then

                        r(7 downto 0) := mout(7 downto 0);

                        if (mout(7) = '0') then
                            
                            r(31 downto 8) := zero(23 downto 0); 
                        
                        else
                    
                            r(31 downto 8) := one(23 downto 0); 

                        end if;

                    elsif (padrs = "01") then

                        r(7 downto 0) := mout(15 downto 8);

                        if (mout(15) = '0') then
                            
                            r(31 downto 8) := zero(23 downto 0); 
                        
                        else
                    
                            r(31 downto 8) := one(23 downto 0); 

                        end if;

                    elsif (padrs = "10") then

                        r(7 downto 0) := mout(23 downto 16);

                        if (mout(23) = '0') then
                            
                            r(31 downto 8) := zero(23 downto 0); 
                        
                        else
                    
                            r(31 downto 8) := one(23 downto 0); 

                        end if;

                    elsif (padrs = "11") then

                        r(7 downto 0) := mout(31 downto 24);

                        if (mout(31) = '0') then
                            
                            r(31 downto 8) := zero(23 downto 0); 
                        
                        else
                    
                            r(31 downto 8) := one(23 downto 0); 

                        end if;

                    end if;
                
                elsif (instruction(6 downto 5) = "11") then --ldrsh
                
                    if (padrs = "00") then

                        r(15 downto 0) := mout(15 downto 0);

                        if (mout(15) = '0') then
                            
                            r(31 downto 16) := zero(15 downto 0); 
                        
                        else
                    
                            r(31 downto 16) := one(15 downto 0); 

                        end if;

                    elsif (padrs = "10") then

                        r(15 downto 0) := mout(31 downto 16);

                        if (mout(31) = '0') then
                            
                            r(31 downto 16) := zero(15 downto 0); 
                        
                        else
                    
                            r(31 downto 16) := one(15 downto 0); 

                        end if;

                    end if;
                
                end if ;

            else --ldr, ldrb

                if (instruction(22) = '0') then --ldr

                    r := mout;

                else --ldrb

                    if (padrs = "00") then

                        r(7 downto 0) := mout(7 downto 0);

                    elsif (padrs = "01") then

                        r(7 downto 0) := mout(15 downto 8);

                    elsif (padrs = "10") then

                        r(7 downto 0) := mout(23 downto 16);

                    elsif (padrs = "11") then

                        r(7 downto 0) := mout(31 downto 24);

                    end if;

                end if;
                
            end if;

        end if;
        
        min <= m;
        rin <= r;

    end process;

end architecture bev;