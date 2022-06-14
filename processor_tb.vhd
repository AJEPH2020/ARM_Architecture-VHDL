library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity processor is
end entity processor;

architecture bev of processor is

component programCounter is 
    port( clk: in std_logic;
        PC_Start: in std_logic_vector(31 downto 0);
        rset: in std_logic;
        move: in std_logic;
        branchOffset: in std_logic_vector(23 downto 0);
        pcOut: out std_logic_vector(31 downto 0)
);
end component;

signal PC_Start: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal rset: std_logic:='0';
signal move: std_logic:='0';
signal branchOffset: std_logic_vector(23 downto 0):="000000000000000000000000";
signal pcOut: std_logic_vector(31 downto 0);



component CondCheck is
    port( ccinZ: in std_logic;
        condition: in std_logic_vector(3 downto 0);
        ccoutput: out std_logic
		);
end component;

signal ccinZ: std_logic:='0';
signal condition: std_logic_vector(3 downto 0):="0000";
signal ccoutput: std_logic;



component Flags is
    port( clk: in std_logic;
        setFlags: in std_logic;
        inC, inV, inZ, inN: in std_logic;
        outC, outV, outZ, outN: out std_logic
    );
end component;

signal inC, inV, inZ, inN: std_logic:='0';
signal setFlags: std_logic:='0';
signal outC, outV, outZ, outN: std_logic;



component ALU is
    Port (
        A, B     : in  std_logic_vector(31 downto 0);
        ALU_Select  : in  std_logic_vector(3 downto 0);
        ALU_Output   : out  std_logic_vector(31 downto 0);
        cin, vin, zin ,nin : in std_logic;
        cout, vout, zout, nout : out std_logic
    );
end component;

signal A : std_logic_vector(31 downto 0) := (others => '0');
signal B : std_logic_vector(31 downto 0) := (others => '0');
signal ALU_Select : std_logic_vector(3 downto 0) := (others => '0');
signal ALU_Output : std_logic_vector(31 downto 0);
signal cin, vin, zin ,nin : std_logic := '0';
signal cout, vout, zout, nout : std_logic;



component RegisterFile IS
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
end component;

SIGNAL Write1: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL Data: STD_LOGIC_VECTOR(31 DOWNTO 0):="00000000000000000000000000000000";
SIGNAL WriteOn: STD_LOGIC:='0';
SIGNAL Read1: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL Read2: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL out1: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL out2: STD_LOGIC_VECTOR(31 DOWNTO 0);



component dataMemory is
    port(
        clk: in std_logic;
        writeOnDm: in std_logic;
        adrsdm: in std_logic_vector(5 downto 0);
        Din: in std_logic_vector(31 downto 0);
        bytes: in std_logic_vector(3 downto 0);
        outputdm: out std_logic_vector(31 downto 0);
    
        adrspm: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        outputpm: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
end component;

signal writeOnDm: std_logic:='0';
signal adrsdm: std_logic_vector(5 downto 0):="000000";
signal Din: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal bytes: std_logic_vector(3 downto 0):="0000";
signal outputdm: std_logic_vector(31 downto 0);

SIGNAL adrspm: STD_LOGIC_VECTOR(5 DOWNTO 0):="000000";
SIGNAL outputpm: STD_LOGIC_VECTOR(31 DOWNTO 0);



component fsm is
    port(
        inA, inB, inIR, inDR, inRES: in std_logic_vector(31 downto 0);
        fsminput: in std_logic_vector(3 downto 0);
        fsmoutput: out std_logic_vector(3 downto 0);
        outA, outB, outIR, outDR, outRES: out std_logic_vector(31 downto 0)
        );
end component;

signal inA, inB, inIR, inDR, inRES: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal fsminput: STD_LOGIC_VECTOR(3 downto 0):="0000";
signal fsmoutput: STD_LOGIC_VECTOR(3 downto 0);
signal outA, outB, outIR, outDR, outRES: std_logic_vector(31 downto 0);
 


component shift is
    port( sindata: in std_logic_vector(31 downto 0);
        sinshifttype: in std_logic_vector(1 downto 0);
        sinshiftamount: in std_logic_vector(4 downto 0);
        scin: in std_logic;
        soutdata: out std_logic_vector(31 downto 0);
        scout: out std_logic
		);
end component;

signal sindata: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal sinshifttype: STD_LOGIC_VECTOR(1 downto 0):="00";
signal sinshiftamount: STD_LOGIC_VECTOR(4 downto 0):="00000";
signal scin: std_logic:='0';
signal soutdata: std_logic_vector(31 downto 0);
signal scout: std_logic;



component pmconnect is
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
end component;

signal rout,mout,instruction: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal padrs: STD_LOGIC_VECTOR(1 downto 0):="00";
signal sl: std_logic:='0';
signal pmcon: std_logic:='0';
signal rin,min: std_logic_vector(31 downto 0);
signal mw: std_logic_vector(3 downto 0);




signal clk: std_logic:='0';
signal mclk: std_logic:='0';






begin
	u1: entity work.programCounter PORT MAP (clk,PC_Start,rset,move,branchOffset,pcOut);
    u2: entity work.CondCheck PORT MAP (ccinZ,condition,ccoutput);
    u3: entity work.Flags PORT MAP (clk,setFlags,inC, inV, inZ, inN,outC, outV, outZ, outN);
    u4: entity work.ALU PORT MAP (A, B,ALU_Select,ALU_Output,cin, vin, zin ,nin,cout, vout, zout, nout);
    u5: entity work.RegisterFile PORT MAP (Write1,Data,WriteOn,Read1,Read2,clk,out1,out2);
    u7: entity work.dataMemory PORT MAP (clk,writeOnDm,adrsdm,Din,bytes,outputdm,adrspm,outputpm);
    u8: entity work.fsm PORT MAP (inA, inB, inIR, inDR, inRES, fsminput, fsmoutput, outA, outB, outIR, outDR, outRES);
    u9: entity work.shift PORT MAP (sindata,sinshifttype,sinshiftamount,scin,soutdata,scout);
    u10:entity work.pmconnect PORT MAP (rout,mout,instruction,padrs,sl,pmcon,rin,min,mw);
   
   clk_cycle: process
	begin
    	clk<='1';
    	wait for 5 ns;
    	clk<='0';
    	wait for 5 ns;
	end process;

    m_clock: process
	begin
    	mclk<='1';
    	wait for 20 ns;
    	mclk<='0';
    	wait for 20 ns;
	end process;


process
    begin

    PC_Start <= X"00000000";
    rset <= '1';
    setFlags <= '1';
    wait for 11 ns;
    rset <= '0';
   	setFlags <= '0';

    
while outputpm /= X"00000000" loop


    


    case(fsmoutput) is
    when "0001" =>--1

        adrspm <= pcOut(5 downto 0);
        wait for 11 ns;

        inIR <= outputpm;

        move <= '1';
        wait for 11 ns;
        move <= '0';

        fsminput <= "0001";

        if (outputpm = X"00000000") then
            exit;
        end if;

        wait until RISING_EDGE(mclk);






    when "0010" =>--2
        if (outIR(27 downto 26) = "00") then --add,sub,cmp,mov


            if (outIR(27 downto 25) = "000" and outIR(7) = '1' and outIR(4) = '1') then

            
                Read1 <= outIR(19 downto 16);
                Read2 <= outIR(15 downto 12);
                wait for 11 ns;

                inA <= out1;
                inB <= out2;
    
            else
    
                Read1 <= outIR(19 downto 16);
                Read2 <= outIR(3 downto 0);
                Write1 <= outIR(15 downto 12);
                WriteOn <= '0';
                wait for 11 ns;
                
                inA <= out1;
                inB <= out2;
    
            end if;


            

        elsif (outIR(27 downto 26) = "01") then
        
            Read1 <= outIR(19 downto 16);
            Read2 <= outIR(15 downto 12);
            wait for 11 ns;

            inA <= out1;
            inB <= out2;

        end if;

        fsminput <= "0010";

        wait until RISING_EDGE(mclk);






    when "0011" =>--3
            
        if (outIR(20) = '1') then
            cin <= outC;
            vin <= outV;
            zin <= outZ;
            nin <= outN;
        end if;

        if (outIR(25) = '0') then --through register

            A <= outA;
            sindata <= outB;
            sinshifttype <= outIR(6 downto 5);
            scin <= outC;
            if (outIR(4) = '0') then
                sinshiftamount <= outIR(11 downto 7);
            else
                Read1 <= outIR(11 downto 8);
                wait for 6 ns;
                sinshiftamount <= out1(4 downto 0);
            end if;
            wait for 1 ns;
            B <= soutdata;
            inC <= scout;
            
            ALU_Select <= outIR(24 downto 21);
            wait for 11 ns;
            
        elsif (outIR(25) = '1') then --immediate

            A <= outA;

            sindata <= X"00000000" + outIR(7 downto 0);
            sinshifttype <= "11";
            scin <= outC;
            sinshiftamount <= outIR(11 downto 8) & '0';
            wait for 1 ns;
            B <= soutdata;
            inC <= scout;

            ALU_Select <= outIR(24 downto 21);
            wait for 11 ns;

        end if;

        if (outIR(20) = '1') then
            inC <= cout;
            inV <= vout;
            inZ <= zout;
            inN <= nout;
            setFlags <= '1';
            wait for 11 ns;
            setFlags <= '0';
        end if;

        inRES <= ALU_Output;
      
        fsminput <= "0011";

        wait until RISING_EDGE(mclk);



    when "0100" =>--4
        
        if (outIR(25) = '0') then
            if (outIR(23) = '1') then
                A <= outA;

                if (outIR(27 downto 25) = "000" and outIR(7) = '1' and outIR(4) = '1') then

            
                    B <= X"000000" & outIR(11 downto 8) & outIR(3 downto 0);
        
                else
        
                    B <= X"00000000" + outIR(11 downto 0);
        
                end if;
                
                ALU_Select <= "0100";
                wait for 11 ns;
                inRES <= ALU_Output;
            elsif (outIR(23) = '0') then
                A <= outA;

                if (outIR(27 downto 25) = "000" and outIR(7) = '1' and outIR(4) = '1') then

            
                    B <= X"000000" & outIR(11 downto 8) & outIR(3 downto 0);
        
                else
        
                    B <= X"00000000" + outIR(11 downto 0);
        
                end if;

                ALU_Select <= "0010";
                wait for 11 ns;
                inRES <= ALU_Output;
            end if;
        else
            Read2 <= outIR(3 downto 0);
            wait for 6 ns;
            sindata <= out2;
            sinshifttype <= outIR(6 downto 5);
            scin <= outC;
            if (outIR(4) = '0') then
                sinshiftamount <= outIR(11 downto 7);
            else
                Read1 <= outIR(11 downto 8);
                wait for 6 ns;
                sinshiftamount <= out1(4 downto 0);
            end if;
            wait for 1 ns;
            B <= soutdata;
            inC <= scout;

            if (outIR(23) = '1') then
                A <= outA;
                ALU_Select <= "0100";
                wait for 11 ns;
                inRES <= ALU_Output;
            elsif (outIR(23) = '0') then
                A <= outA;
                ALU_Select <= "0010";
                wait for 11 ns;
                inRES <= ALU_Output;
            end if;
        end if;


        fsminput <= "0100";

        wait until RISING_EDGE(mclk);



    when "0101" =>--5

        ccinZ <= outZ;
        condition <= outIR(31 downto 28);
        wait for 11 ns;


        if (ccoutput = '1') then
            

            branchOffset <= outIR(23 downto 0);
            move <= '1';
            wait for 11 ns;
            move <= '0';
            branchOffset <= X"000000";

        end if;
        
        fsminput <= "0101";

        wait until RISING_EDGE(mclk);



    when "0110" =>--6


		if (ALU_Select /= "1000") then
            if (ALU_Select /= "1001") then
                if (ALU_Select /= "1010") then
                    if (ALU_Select /= "1011") then
                        if (ALU_Select /= "1111") then
                            Data <= outRES;
                            WriteOn <= '1';
                            wait for 11 ns;
                            WriteOn <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
        
        fsminput <= "0110";

        wait until RISING_EDGE(mclk);



    when "0111" =>--7

        if (outIR(24) = '0' and outIR(21) = '0') then

            adrsdm <= outA(7 downto 2);

            padrs <= outA(1 downto 0);

        else

            adrsdm <= outRES(7 downto 2);

            padrs <= outRES(1 downto 0);

        end if;

        
        rout <= outB;
        instruction <= outIR;
        sl <= '0';
        pmcon <= not(pmcon);
        wait for 6 ns;


        Din <= min;
        bytes <= mw;
        writeOnDm <= '1';
        wait for 11 ns;
        writeOnDm <= '0';

        if (outIR(24) = '1' and outIR(21) = '1') then

            write1 <= outIR(19 downto 16);
            Data <= outRES;
            WriteOn <= '1';
            wait for 11 ns;
            WriteOn <= '0';

        end if;

        if (outIR(24) = '0' and outIR(21) = '0') then

            write1 <= outIR(19 downto 16);
            Data <= outRES;
            WriteOn <= '1';
            wait for 11 ns;
            WriteOn <= '0';

        end if;

        fsminput <= "0111";

        wait until RISING_EDGE(mclk);

        

    when "1000" =>--8
        
        if (outIR(24) = '0' and outIR(21) = '0') then

            adrsdm <= outA(7 downto 2);
            wait for 6 ns;

            padrs <= outA(1 downto 0);

        else

            adrsdm <= outRES(7 downto 2);
            wait for 6 ns;
            
            padrs <= outRES(1 downto 0); 

        end if;

        mout <= outputdm;
        instruction <= outIR;
        sl <= '1';
        pmcon <= not(pmcon);
        wait for 6 ns;

 
        inDR <= rin;
        fsminput <= "1000";
        

        


        wait until RISING_EDGE(mclk);



    when "1001" =>--9

        Data <= outDR;
        Write1 <= outputpm(15 downto 12);
        WriteOn <='1';
        wait for 11 ns;
        WriteOn <='0';
    
        if (outIR(24) = '1' and outIR(21) = '1') then

            write1 <= outIR(19 downto 16);
            Data <= outRES;
            WriteOn <= '1';
            wait for 11 ns;
            WriteOn <= '0';

        end if;

        if (outIR(24) = '0' and outIR(21) = '0') then

            write1 <= outIR(19 downto 16);
            Data <= outRES;
            WriteOn <= '1';
            wait for 11 ns;
            WriteOn <= '0';

        end if;

        fsminput <= "1001";


        wait until RISING_EDGE(mclk);



    when others => NULL; 
    end case;

end loop;



Read1 <= "0000";
wait for 11 ns;
Read1 <= "0001";
wait for 11 ns;
Read1 <= "0010";
wait for 11 ns;
Read1 <= "0011";
wait for 11 ns;
Read1 <= "0100";
wait for 11 ns;
Read1 <= "0101";
wait for 11 ns;
Read1 <= "0110";
wait for 11 ns;
Read1 <= "0111";
wait for 11 ns;
Read1 <= "1000";
wait for 11 ns;
Read1 <= "1001";
wait for 11 ns;
Read1 <= "1010";
wait for 11 ns;
Read1 <= "1011";
wait for 11 ns;
Read1 <= "1100";
wait for 11 ns;
Read1 <= "1101";
wait for 11 ns;
Read1 <= "1110";
wait for 11 ns;
Read1 <= "1111";
wait for 11 ns;

adrsdm <= "000010";
wait for 11 ns;

adrsdm <= "000011";
wait for 11 ns;

adrsdm <= "000100";
wait for 11 ns;


wait;
end process;
end bev;

