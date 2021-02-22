----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2020 05:26:45 PM
-- Design Name: 
-- Module Name: mem - Behavioral
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

entity mem is
  Port (memWr: in std_logic;
  aluResIn: in std_logic_vector (15 downto 0);
  rd2: in std_logic_vector(15 downto 0);
  memData: out std_logic_vector(15 downto 0);
  aluResOut: out std_logic_vector(15 downto 0));
end mem;

architecture Behavioral of mem is

type ram_type is array (0 to 127) of std_logic_vector(15 downto 0);
   signal ram : ram_type :=(    
0 => "0000000000000000",
1 => "0000000000000000",
2 => "0000000000000000",
3 => "0000000000000000",
4 => "0000000000000000",
others => "0000000000000000");

signal read_address : std_logic_vector(15 downto 0) := x"0000";

begin

process(memWr) is
  begin
      if memWr = '1' then
        ram(conv_integer(aluResIn)) <= rd2;
      end if;
end process;
  
read_address <= aluResIn;
memData <= ram(conv_integer(read_address));

end Behavioral;
