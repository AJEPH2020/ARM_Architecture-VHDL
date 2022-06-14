library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shift is
    port( sindata: in std_logic_vector(31 downto 0);
        sinshifttype: in std_logic_vector(1 downto 0);
        sinshiftamount: in std_logic_vector(4 downto 0);
        scin: in std_logic;
        soutdata: out std_logic_vector(31 downto 0);
        scout: out std_logic
		);
end entity shift;

architecture bev of shift is

    signal c: std_logic:='0';

begin
process (sindata,sinshifttype,sinshiftamount,scin)

    variable zero: std_logic_vector(15 downto 0):="0000000000000000";
    variable  one: std_logic_vector(15 downto 0):="1111111111111111";

    variable sdata: std_logic_vector(31 downto 0):="00000000000000000000000000000000";

    begin

        sdata := sindata;
        c <= scin;

        if (sinshiftamount(0) = '1') then
            if (sinshifttype = "00") then --LSL
                c <= sdata(31);
                sdata := sdata(30 downto 0) & zero(0);
            else
                c <= sdata(0);
                if (sinshifttype = "01") then --LSR
                    sdata := zero(0) & sdata(31 downto 1);

                elsif (sinshifttype = "10") then --ASR

                    if (sdata(31) = '1') then
                        sdata := one(0) & sdata(31 downto 1)  ;
                    else
                        sdata := zero(0) & sdata(31 downto 1)  ;
                    end if;

                elsif (sinshifttype = "11") then --ROR
                    sdata := sdata(0) & sdata(31 downto 1)  ;

                end if;
            end if;
        end if;
        if (sinshiftamount(1) = '1') then
            if (sinshifttype = "00") then --LSL
                c <= sdata(30);
                sdata := sdata(29 downto 0) & zero(1 downto 0)  ;
            else
                c <= sdata(1);
                if (sinshifttype = "01") then --LSR
                    sdata := zero(1 downto 0) & sdata(31 downto 2)  ;

                elsif (sinshifttype = "10") then --ASR

                    if (sdata(31) = '1') then
                        sdata := one(1 downto 0) & sdata(31 downto 2)  ;
                    else
                        sdata := zero(1 downto 0) & sdata(31 downto 2)  ;
                    end if;

                elsif (sinshifttype = "11") then --ROR

                    sdata := sdata(1 downto 0) & sdata(31 downto 2)  ;

                end if;
            end if;
        end if;
        if (sinshiftamount(2) = '1') then
            if (sinshifttype = "00") then --LSL
                c <= sdata(28);
                sdata := sdata(27 downto 0) & zero(3 downto 0)  ;
            else
                c <= sdata(3);
                if (sinshifttype = "01") then --LSR

                    sdata := zero(3 downto 0) & sdata(31 downto 4)  ;

                elsif (sinshifttype = "10") then --ASR

                    if (sdata(31) = '1') then
                        sdata := one(3 downto 0) & sdata(31 downto 4)  ;
                    else
                        sdata := zero(3 downto 0) & sdata(31 downto 4)  ;
                    end if;

                elsif (sinshifttype = "11") then --ROR

                    sdata := sdata(3 downto 0) & sdata(31 downto 4) ;

                end if;
            end if;
        end if;
        if (sinshiftamount(3) = '1') then
            if (sinshifttype = "00") then --LSL
                c <= sdata(24);
                sdata := sdata(23 downto 0) & zero(7 downto 0) ;
            else
                c <= sdata(7);
                if (sinshifttype = "01") then --LSR

                    sdata := zero(7 downto 0) & sdata(31 downto 8) ;

                elsif (sinshifttype = "10") then --ASR

                    if (sdata(31) = '1') then
                        sdata := one(7 downto 0) & sdata(31 downto 8) ;
                    else
                        sdata := zero(7 downto 0) & sdata(31 downto 8) ;
                    end if;

                elsif (sinshifttype = "11") then --ROR

                    sdata := sdata(7 downto 0) & sdata(31 downto 8) ;

                end if;
            end if;
        end if;
        if (sinshiftamount(4) = '1') then
            if (sinshifttype = "00") then --LSL
                c <= sdata(16);
                sdata := sdata(15 downto 0) & zero(15 downto 0) ;
            else
                c <= sdata(15);
                if (sinshifttype = "01") then --LSR

                    sdata := zero(15 downto 0) & sdata(31 downto 16) ;

                elsif (sinshifttype = "10") then --ASR

                    if (sdata(31) = '1') then
                        sdata := one(15 downto 0) & sdata(31 downto 16) ;
                    else
                        sdata := zero(15 downto 0) & sdata(31 downto 16) ;
                    end if;

                elsif (sinshifttype = "11") then --ROR

                    sdata := sdata(15 downto 0) & sdata(31 downto 16) ;

                end if;
            end if;
        end if;


    soutdata <= sdata;
        
    end process;

    scout <= c;

end architecture bev;