----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 12:17:00 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component mpg is
    Port ( en : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
  Port (digit0 : in STD_LOGIC_VECTOR(3 downto 0);
  digit1 : in STD_LOGIC_VECTOR(3 downto 0);
  digit2 : in STD_LOGIC_VECTOR(3 downto 0);
  digit3 : in STD_LOGIC_VECTOR(3 downto 0);
  clk : in STD_LOGIC;
  LED : out std_logic_vector(6 downto 0);
  O2 : out std_logic_vector(3 downto 0));
end component;

component instr_fetch is
  Port (clk : in std_logic;
  b_adr : in std_logic_vector(15 downto 0);
  en_cnt : in std_logic;
  en_res: in std_logic;
  jmp : in std_logic;
  pc_src : in std_logic;
  pc_next : in std_logic_vector(15 downto 0);
  instr_next : in std_logic_vector(15 downto 0);
  pc_out : out std_logic_vector (15 downto 0);
  instruction : out std_logic_vector(15 downto 0));
end component;

component instr_decode is
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
end component;

component ex_unit is
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
  branch_adr : out std_logic_vector(15 downto 0));
end component;

component mem is
  Port (memWr: in std_logic;
  aluResIn: in std_logic_vector (15 downto 0);
  rd2: in std_logic_vector(15 downto 0);
  memData: out std_logic_vector(15 downto 0);
  aluResOut: out std_logic_vector(15 downto 0));
end component;

--semnale pt IF
signal cnt : std_logic_vector(15 downto 0) := x"0000";
signal pc : std_logic_vector(15 downto 0) := x"0000";
signal pcSrc : std_logic;
signal instr : std_logic_vector(15 downto 0) := x"0000";
signal DO : std_logic_vector(15 downto 0) := x"0000";
signal en1 :std_logic ;
signal en2 :std_logic ;
signal j_adr: std_logic_vector(15 downto 0) := x"0000";
signal b_adr: std_logic_vector(15 downto 0) := x"0000";
signal pc_next: std_logic_vector(15 downto 0) := x"0000";
signal instr_next: std_logic_vector(15 downto 0) := x"0000";

--semnale pt UC
signal regDst : std_logic;
signal extOp : std_logic;
signal aluSrc : std_logic;
signal branch : std_logic;
signal jump : std_logic;
signal aluOp : std_logic_vector(2 downto 0);
signal memWr : std_logic;
signal memToReg : std_logic;
signal regWr : std_logic;

--semnale pt ID
signal rd1 : std_logic_vector(15 downto 0) := x"0000";
signal rd2 : std_logic_vector(15 downto 0) := x"0000";
signal wd : std_logic_vector(15 downto 0) := x"0000";
signal extImm : std_logic_vector(15 downto 0) := x"0000";
signal func : std_logic_vector(2 downto 0);
signal sa : std_logic;
signal rt : std_logic_vector(2 downto 0):="000";
signal rdest : std_logic_vector(2 downto 0):="000";
signal wa : std_logic_vector(2 downto 0):="000";

--semnale pt EX
signal zero : std_logic;
signal aluRes : std_logic_vector(15 downto 0);
signal ex_brAdr : std_logic_vector(15 downto 0);
signal ex_wa : std_logic_vector(2 downto 0):="000";

--semnale pt MEM
signal enMemWr : std_logic;
signal memData : std_logic_vector(15 downto 0);

--semnale pt IF/ID
signal ifid_in : std_logic_vector(31 downto 0):=x"00000000";
signal ifid_out : std_logic_vector(31 downto 0):=x"00000000";

--semnale pt ID/EX
signal idex_in : std_logic_vector(72 downto 0);
signal idex_out: std_logic_vector(72 downto 0);
signal idex_wb_in : std_logic_vector(1 downto 0);
signal idex_wb_out : std_logic_vector(1 downto 0);
signal idex_m_in : std_logic_vector(1 downto 0);
signal idex_m_out : std_logic_vector(1 downto 0);
signal idex_ex_in: std_logic_vector(4 downto 0);
signal idex_ex_out: std_logic_vector(4 downto 0);

--semnale pt EX/MEM
signal exmem_in : std_logic_vector(51 downto 0);
signal exmem_out : std_logic_vector(51 downto 0);
signal exmem_wb_in : std_logic_vector(1 downto 0);
signal exmem_wb_out : std_logic_vector(1 downto 0);
signal exmem_m_in : std_logic_vector(1 downto 0);
signal exmem_m_out : std_logic_vector(1 downto 0);

--semnale pt MEM/WB
signal memwb_in : std_logic_vector(34 downto 0);
signal memwb_out : std_logic_vector(34 downto 0);
signal memwb_wb_in : std_logic_vector(1 downto 0);
signal memwb_wb_out : std_logic_vector(1 downto 0);

begin

MPG_1 : mpg port map(en1, btn(0), clk);
MPG_2 : mpg port map(en2, btn(1), clk);

pc_next<=ifid_out(31 downto 16);
instr_next<=ifid_out(15 downto 0);
b_adr<=exmem_out(51 downto 36);

I_F : instr_fetch port map(clk, b_adr, en1, en2, jump, pcSrc, pc_next, instr_next, pc, instr);

ifid_in(31 downto 16) <= pc;
ifid_in(15 downto 0) <= instr;

IF_ID_reg : process(clk)
begin
if rising_edge(clk) then
    if en1 = '1' then
	   ifid_out <= ifid_in;
	end if;
end if;
end process;

wa<=memwb_out(2 downto 0);

I_D : instr_decode port map(ifid_out(15 downto 0), wa, wd, clk, memwb_wb_out(0), rd1, rd2, extImm, func, sa, rt, rdest, regDst, extOp, aluSrc, branch, jump, aluOp, memWr, memToReg, regWr);

idex_wb_in(1)<=memToReg;
idex_wb_in(0)<= regWr;
idex_m_in(1)<=memWr;
idex_m_in(0)<=branch;
idex_ex_in(4 downto 2)<=aluOp;
idex_ex_in(1)<=aluSrc;
idex_ex_in(0)<=regDst;
idex_in(72 downto 57) <= ifid_out(31 downto 16);
idex_in(56 downto 41) <= rd1;
idex_in(40 downto 25) <= rd2;
idex_in(24 downto 9) <= extImm;
idex_in(8 downto 6) <= func;
idex_in(5 downto 3) <= rt;
idex_in(2 downto 0) <= rdest;

ID_EX_reg : process(clk)
begin
if rising_edge(clk) then
    if en1 = '1' then
        idex_out <= idex_in;
        idex_ex_out <= idex_ex_in;
        idex_wb_out <= idex_wb_in;
        idex_m_out <= idex_m_in;
	end if;
end if;
end process;

E_X : ex_unit port map(idex_out(72 downto 57), idex_out(56 downto 41), idex_ex_out(1), idex_out(40 downto 25), idex_out(24 downto 9), sa, idex_out(8 downto 6), idex_ex_out(4 downto 2), idex_out(5 downto 3), idex_out(2 downto 0), idex_ex_out(0), zero, aluRes, ex_wa, ex_brAdr);  

exmem_in(51 downto 36)<= ex_brAdr;
exmem_in(35)<= zero;
exmem_in(34 downto 19)<= aluRes;
exmem_in(18 downto 3)<= idex_out(40 downto 25);
exmem_in(2 downto 0)<= ex_wa;
exmem_wb_in <= idex_wb_out;
exmem_m_in <= idex_m_out;

EX_MEM_reg : process(clk)
begin
if rising_edge(clk) then
    if en1 = '1' then
        exmem_out <= exmem_in;
        exmem_wb_out <= exmem_wb_in;
        exmem_m_out <= exmem_m_in;
    end if;
end if;
end process;

process(exmem_m_out(1))
begin
      if exmem_m_out(1)='1' then
         enMemWr<= '1';
      else enMemWr<='0';
      end if;
end process;

MEM_RAM : mem port map(enMemWr, exmem_out(34 downto 19), exmem_out(18 downto 3), memData, exmem_out(34 downto 19));

pcSrc<=exmem_m_out(0) and exmem_out(35);

memwb_in(34 downto 19)<= memData;
memwb_in(18 downto 3)<= exmem_out(34 downto 19);
memwb_in(2 downto 0)<= exmem_out(2 downto 0);
memwb_wb_in<= exmem_wb_out;

MEM_WB_reg : process(clk)
begin
if rising_edge(clk) then
    if en1 = '1' then
        memwb_out <= memwb_in;
        memwb_wb_out <= memwb_wb_in;
    --WB
    if memwb_wb_out(1)='0' then
        wd<=memwb_out(18 downto 3);
    else wd<=memwb_out(34 downto 19);
    end if;
    end if;
end if;
end process;

process(sw)
begin
    case (sw(7 downto 5)) is
    when "000" => DO<=instr;
    when "001" => DO<=pc;
    when "010" => DO<=rd1;
    when "011" => DO<=rd2;
    when "100" => DO<=extImm;
    when "101" => DO<=aluRes;
    when "110" => DO<=memData;
    when "111" => DO<=wd;
    end case;
end process;

led(10 downto 8)<=aluOp;
led(7)<=regDst;
led(6)<=extOp;
led(5)<=aluSrc;
led(4)<=branch;
led(3)<=jump;
led(2)<=memWr;
led(1)<=memToReg;
led(0)<=regWr;

SSD_1: SSD port map (DO(15 downto 12), DO(11 downto 8), DO(7 downto 4), DO(3 downto 0), clk, cat, an);

end Behavioral;