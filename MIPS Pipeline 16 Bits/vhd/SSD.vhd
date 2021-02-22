----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 09:06:47 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
  Port (digit0 : in STD_LOGIC_VECTOR(3 downto 0);
  digit1 : in STD_LOGIC_VECTOR(3 downto 0);
  digit2 : in STD_LOGIC_VECTOR(3 downto 0);
  digit3 : in STD_LOGIC_VECTOR(3 downto 0);
  clk : in STD_LOGIC;
  LED : out std_logic_vector(6 downto 0);--catod
  O2 : out std_logic_vector(3 downto 0));--anod
end SSD;

architecture Behavioral of SSD is

signal cnt : std_logic_vector(15 downto 0) := x"0000";
signal O1 : std_logic_vector(3 downto 0);

begin

process(clk)
begin
 if rising_edge(clk) then
         cnt<= cnt + 1;
 end if;
end process;

--luam bitii 15 si 14 pentru ca ne intereseaza sa impartim perioada in 4 pentru a fi observat de ochiul uman
process(cnt(15 downto 14), digit0, digit1, digit2, digit3)
begin
 case cnt(15 downto 14) is
 when "00" => O1 <= digit0;
 when "01" => O1 <= digit1;
 when "10" => O1 <= digit2;
 when others => O1 <= digit3;
 end case;
end process;

process(cnt(15 downto 14))
begin
 case cnt(15 downto 14) is
 when "00" => O2 <= "0111";
 when "01" => O2 <= "1011";
 when "10" => O2 <= "1101";
 when others => O2 <= "1110";
 end case;
end process;

 with O1 SELect
   LED<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
