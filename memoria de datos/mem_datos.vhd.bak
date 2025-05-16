-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo Sumador de 8 Bits Manchester

library ieee;
use ieee.std_logic_1164.all;

entity CSLA is 
	port( A, B : in std_logic_vector(7 downto 0);
			Ci   : in std_logic;
		   S    : out std_logic_vector(7 downto 0);
			Co   : out std_logic);
end entity;

architecture RTL of CSLA is
	--declaramos componentes
	
	component RCA is 
		generic (N :integer :=4);
		port( A, B : in std_logic_vector(N-1 downto 0);
				Ci   : in std_logic;
				S    : out std_logic_vector(N-1 downto 0);
				Co   : out std_logic);
	end component;
	
	-- declaramos las señales necesarias
	signal S_block0 : std_logic_vector (3 downto 0);
	signal C_block0 : std_logic;
	
	signal S_block1_c0, S_block1_c1 : std_logic_vector (3 downto 0);
	signal C_block1_c0, C_block1_c1 : std_logic;
	
	begin
			Block0 : RCA port map (A(3 downto 0), B(3 downto 0), Ci, S_block0,  C_block0);
			Block1_c0 : RCA port map (A(7 downto 4), B(7 downto 4), '0', S_block1_c0, C_block1_c0);
			Block1_c1 : RCA port map (A(7 downto 4), B(7 downto 4), '0', S_block1_c1, C_block1_c1);
			
			with C_block0 select
				Co <= C_block1_c1  when '1',
					   C_block1_c0 when '0';
			
			S(3 downto 0) <= S_block0;
			
			with C_block0 select
				S(7 downto 4) <= S_block1_c1  when '1',
					              S_block1_c0 when '0';
			
end architecture;

