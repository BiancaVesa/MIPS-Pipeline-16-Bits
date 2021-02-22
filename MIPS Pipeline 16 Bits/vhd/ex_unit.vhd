----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2020 02:48:17 PM
-- Design Name: 
-- Module Name: ex_unit - Behavioral
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

entity ex_unit is
  Port (
  pc_next : in std_logic_vector(15 downto 0);
  rd1 : in std_logic_vector(15 downto 0);
  aluSrc : in std_logic;
  rd2 : in std_logic_vector(15 downto 0); 
  ext_imm : in std_logic_vector(15 downto 0); 
  sa : in std_logic;
  func : in std_logic_vector(2 downto 0);
  aluOp : in std_logic_vector(2 downto 0);
  rt : in std_logic_vector(2 downto 0);
  rdest : in std_logic_vector(2 downto 0);
  regDst : in std_logic;
  zero : out std_logic;
  aluRes : out std_logic_vector(15 downto 0);
  wa : out std_logic_vector(2 downto 0);
  branch_adr : out std_logic_vector (15 downto 0));
end ex_unit;

architecture Behavioral of ex_unit is

signal aluCtrl : std_logic_vector(2 downto 0) := "000";
signal t1 : std_logic_vector(15 downto 0) := x"0000";
signal t2 : std_logic_vector(15 downto 0) := x"0000";
signal t : std_logic_vector(15 downto 0) := x"0000";
signal suma : std_logic_vector(15 downto 0) := x"0000";
signal dif : std_logic_vector(15 downto 0) := x"0000";
signal shd : std_logic_vector(15 downto 0) := x"0000";
signal shs : std_logic_vector(15 downto 0) := x"0000";
signal andl : std_logic_vector(15 downto 0) := x"0000";
signal orl : std_logic_vector(15 downto 0) := x"0000";
signal xorl : std_logic_vector(15 downto 0) := x"0000";
signal nandl : std_logic_vector(15 downto 0) := x"0000";

begin

t1 <= rd1;

process(aluSrc)
begin
    if aluSrc = '0' then
        t2<=rd2;
    else t2<=ext_imm;
    end if;
end process;

--ALU Control
process(aluCtrl)
begin
    case aluOp is
    when "000" => case func is
                      when "000" => aluCtrl<="000"; -- (add)
                      when "001" => aluCtrl<="001"; -- (sub)
                      when "010" => aluCtrl<="010"; -- (sll)
                      when "011" => aluCtrl<="011"; -- (srl)
                      when "100" => aluCtrl<="100"; -- (and)
                      when "101" => aluCtrl<="101"; -- (or)
                      when "110" => aluCtrl<="110"; -- (xor)
                      when "111" => aluCtrl<="111"; -- (nand)
                 end case;
    when "001" => aluCtrl<="000"; -- (addi)
    when "010" => aluCtrl<="000"; -- (lw)
    when "011" => aluCtrl<="000"; -- (sw)
    when "100" => aluCtrl<="001"; -- (beq)
    when "101" => aluCtrl<="001"; -- (bne)
    when "110" => aluCtrl<="110"; -- (xori)
    when others => aluCtrl<="000";
    end case;
end process;

--ALU        
suma<= t1 + t2;
dif<= t1 - t2;
shs<= t(14 downto 0) & "0";
shd<= "0" & t(14 downto 0);
andl<= t1 and t2;
orl<= t1 or t2;
xorl<= t1 xor t2;
nandl<= t1 nand t2; 

process(aluCtrl)
begin
case aluCtrl is
     when "000" => t <= suma;
     when "001" => t <= dif;
     when "010" => t <= shs;
     when "011" => t <= shd;
     when "100" => t <= andl;
     when "101" => t <= orl;
     when "110" => t <= xorl;
     when "111" => t <= nandl;
end case;
end process;

aluRes<= t;

process(aluCtrl)
begin
    if aluCtrl = "001" then
        if dif = x"0000" then
            zero<= '1';
        else zero<= '0';
       end if;
    end if;
end process;    

process(regDst)
begin
    if regDst = '0' then
       wa <= rt;
    else wa <= rdest;
    end if;
end process;

branch_adr <= pc_next + ext_imm;
 
end Behavioral;
