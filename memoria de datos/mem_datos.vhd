-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo Sumador de 8 Bits Manchester

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mem_datos is 
	port( clk, wr : in std_logic;
			address  : in std_logic_vector (6 downto 0);
		   data_in : in std_logic_vector(7 downto 0);
			data_out: out std_logic_vector(7 downto 0));
end entity;

architecture RTL of mem_datos is
	
	type mem_dato is array (0 to 95) of std_logic_vector (7 downto 0);
	
	-- declaramos las señales necesarias
	signal RAM: mem_dato := (
		x"00", x"00", x"11", x"00", --0x80: (vacío)
		x"00", x"00", x"00", x"00", --0x84: (vacío)
		x"00", x"00", x"00", x"00", --0x88: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x80: (vacío)
		
		x"00", x"00", x"00", x"00", --0x84: (vacío)
		x"00", x"00", x"00", x"00", --0x88: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x80: (vacío)
		x"00", x"00", x"00", x"00", --0x84: (vacío)
		
		x"00", x"00", x"00", x"00", --0x88: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x80: (vacío)
		x"00", x"00", x"00", x"00", --0x84: (vacío)
		x"00", x"00", x"00", x"00", --0x88: (vacío)
		
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x80: (vacío)
		x"00", x"00", x"00", x"00", --0x84: (vacío)
		x"00", x"00", x"00", x"00", --0x88: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00", --0x8c: (vacío)
		x"00", x"00", x"00", x"00"  --0x8c: (vacío)
		
		);
	
	begin
	process(clk)
			begin
				if (clk'event and clk='1') then
					if (wr='1') then
						RAM(conv_integer(unsigned(address))) <= data_in;
					else
						data_out <= RAM (conv_integer(unsigned(address)));
					end if;
				end if;
			end process;
end architecture;

