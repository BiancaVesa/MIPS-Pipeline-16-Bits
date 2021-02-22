----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2020 01:40:31 PM
-- Design Name: 
-- Module Name: instr_decode - Behavioral
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

entity instr_decode is
  Port ( instr : in std_logic_vector(15 downto 0);
  wa : in std_logic_vector(2 downto 0);
  wd : in std_logic_vector(15 downto 0);
  clk : in std_logic;
  regW : in std_logic;
  rd1 : out std_logic_vector(15 downto 0);
  rd2 : out std_logic_vector(15 downto 0);
  extImm : out std_logic_vector(15 downto 0);
  func : out std_logic_vector(2 downto 0);
  sa : out std_logic;
  rt : out std_logic_vector(2 downto 0);
  rdest : out std_logic_vector(2 downto 0);
  regDst : out std_logic;
  extOp : out std_logic;
  aluSrc : out std_logic;
  branch : out std_logic;
  jump : out std_logic;
  aluOp : out std_logic_vector(2 downto 0);
  memWr : out std_logic;
  memToReg : out std_logic;
  regWr : out std_logic);
end instr_decode;

architecture Behavioral of instr_decode is

component reg_file is
  Port (
  ra1 : in std_logic_vector(2 downto 0);
  ra2 : in std_logic_vector(2 downto 0);
  wa : in std_logic_vector(2 downto 0);
  wd : in std_logic_vector(15 downto 0);
  clk : in std_logic;
  wr_en : in std_logic;
  rd1 : out std_logic_vector(15 downto 0);
  rd2 : out std_logic_vector(15 downto 0));
end component;

signal rs : std_logic_vector(2 downto 0):="000";
signal rt1 : std_logic_vector(2 downto 0):="000";
signal rdest1 : std_logic_vector(2 downto 0):="000";
signal imm : std_logic_vector(6 downto 0);
signal regWrite : std_logic;
signal extOperation : std_logic;
begin

rs <= instr(12 downto 10);
rt1 <= instr(9 downto 7);
rdest1 <= instr(6 downto 4);
imm <= instr(6 downto 0);

RF: reg_file port map(rs, rt1, wa, wd, clk, regW, rd1, rd2);

--UC
process(instr)
begin
    case (instr(15 downto 13)) is
        when "000" => regDst<='1'; extOperation<='0'; aluSrc<='0'; branch<='0'; jump<='0'; aluOp<="000"; memWr<='0'; memToReg<='0'; regWrite<='1'; --tip R
        when "001" => regDst<='0'; extOperation<='1'; aluSrc<='1'; branch<='0'; jump<='0'; aluOp<="001"; memWr<='0'; memToReg<='0'; regWrite<='1'; --addi
        when "010" => regDst<='0'; extOperation<='1'; aluSrc<='1'; branch<='0'; jump<='0'; aluOp<="010"; memWr<='0'; memToReg<='1'; regWrite<='1'; --lw
        when "011" => regDst<='0'; extOperation<='1'; aluSrc<='1'; branch<='0'; jump<='0'; aluOp<="011"; memWr<='1'; memToReg<='0'; regWrite<='0'; --sw
        when "100" => regDst<='0'; extOperation<='1'; aluSrc<='0'; branch<='1'; jump<='0'; aluOp<="100"; memWr<='0'; memToReg<='0'; regWrite<='0'; --beq
        when "101" => regDst<='0'; extOperation<='1'; aluSrc<='0'; branch<='1'; jump<='0'; aluOp<="101"; memWr<='0'; memToReg<='0'; regWrite<='0'; --bne
        when "110" => regDst<='0'; extOperation<='1'; aluSrc<='1'; branch<='0'; jump<='0'; aluOp<="110"; memWr<='0'; memToReg<='0'; regWrite<='1'; --xori
        when "111" => regDst<='0'; extOperation<='0'; aluSrc<='0'; branch<='0'; jump<='1'; aluOp<="111"; memWr<='0'; memToReg<='0'; regWrite<='0'; --j
    end case;
end process;

regWr <= regWrite;
extOp <= extOperation;


process (extOperation)
begin
    if extOperation = '0' then
        extImm <= "000000000" & imm;
    elsif imm(6) = '0' then
        extImm <= "000000000" & imm;
        else extImm <= "111111111" & imm;
    end if;  
end process;

func <= imm(2 downto 0);
sa <= imm(3);
rt <= rt1;
rdest <= rdest1;


end Behavioral;
