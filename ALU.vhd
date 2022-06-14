-- Name: Atul Jeph
-- Entry No: 2020CS10329
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;


entity ALU is
    Port (
    A, B     : in  std_logic_vector(31 downto 0);
    ALU_Select  : in  std_logic_vector(3 downto 0);
    ALU_Output   : out  std_logic_vector(31 downto 0);
    cin, vin, zin ,nin : in std_logic;
    cout, vout, zout, nout : out std_logic
    );
end ALU;


architecture Behavioral of ALU is

signal ALU_Bit : std_logic_vector (31 downto 0);
signal temprary: std_logic_vector (32 downto 0);

begin
  process(ALU_Select, A, B)
  begin
  case(ALU_Select) is
  when "0000" =>
    ALU_Bit <= A and B ;

  when "0001" =>
    ALU_Bit <= A xor B ;

  when "0010" =>
    ALU_Bit <= A + not(B) + "1";
    temprary <= ('0' & A) + ('0' & not(B)) + "1";

  when "0011" =>
    ALU_Bit <= not(A) + B + "1";
    temprary <= ('0' & not(A)) + ('0' & B) + "1";

  when "0100" =>
    ALU_Bit <= A + B;
    temprary <= ('0' & A) + ('0' & B);

  when "0101" =>
    IF(cin='1') THEN
			ALU_Bit <= A + B + "1";
			temprary <= ('0' & A) + ('0' & B) + "1";
		ELSE
      ALU_Bit <= A + B;
      temprary <= ('0' & A) + ('0' & B);
		END IF;
    
  when "0110" =>
    IF(cin='1') THEN
			ALU_Bit <= A + not(B) + "1";
			temprary <= ('0' & A) + ('0' & not(B)) + "1";
		ELSE
      ALU_Bit <= A + not(B);
      temprary <= ('0' & A) + ('0' & not(B));
		END IF;
    
  when "0111" =>
    IF(cin='1') THEN
			ALU_Bit <= not(A) + B + "1";
			temprary <= ('0' & not(A)) + ('0' & B) + "1";
    ELSE
      ALU_Bit <= not(A) + B;
      temprary <= ('0' & not(A)) + ('0' & B);
		END IF;
    
  when "1000" =>
    ALU_Bit <= A and B;
    
  when "1001" =>
    ALU_Bit <= A xor B;
    
  when "1010" =>
	  ALU_Bit <= A + not(B) + "1";
	  temprary <= ('0' & A) + ('0' & not(B)) + "1";
  
  when "1011" =>
    ALU_Bit <= A + B;
    temprary <= ('0' & A) + ('0' & B);
    
  when "1100" =>
    ALU_Bit <= A or B;
    
  when "1101" =>
    ALU_Bit <= B;
    
  when "1110" =>
    ALU_Bit <= A and not(B);
    
  when "1111" => 
    ALU_Bit <= not(B);
    
  when others => NULL; 

 end case;

end process;

Z_bit: process
begin
	if (ALU_Bit = (ALU_Bit'range => '0')) then
 	 	zout <= '1';
	else 
  		zout <= '0';
	end if;
    
    
  if (ALU_Bit(31) = '1') then
 	 	nout <= '1';
	else 
  		nout <= '0';
	end if;
    
    
  if (temprary(32) = '1') then
  		cout <= '1';
	else 
  		cout <= '0';
	end if;

  wait for 5 ns;
    
end process;

 ALU_Output <= ALU_Bit;
 vout <= vin;



end Behavioral;
