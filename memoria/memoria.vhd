-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo Memoria Completa

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity memoria is 
	port( clk, rst, wr : in std_logic;
			address      : in std_logic_vector (7 downto 0);
		   data_in      : in std_logic_vector(7 downto 0);
			p_in_00, p_in_01, p_in_02, p_in_03 : in std_logic_vector(7 downto 0);
			p_in_04, p_in_05, p_in_06, p_in_07 : in std_logic_vector(7 downto 0);
			p_in_08, p_in_09, p_in_10, p_in_11 : in std_logic_vector(7 downto 0);
			p_in_12, p_in_13, p_in_14, p_in_15 : in std_logic_vector(7 downto 0);
			data_out     : out std_logic_vector(7 downto 0);
			p_out_00, p_out_01, p_out_02, p_out_03 : out std_logic_vector(7 downto 0);
			p_out_04, p_out_05, p_out_06, p_out_07 : out std_logic_vector(7 downto 0);
			p_out_08, p_out_09, p_out_10, p_out_11 : out std_logic_vector(7 downto 0);
			p_out_12, p_out_13, p_out_14, p_out_15 : out std_logic_vector(7 downto 0));
end entity;

architecture RTL of memoria is
	
	component mem_datos is 
	port( clk, wr : in std_logic;
			address  : in std_logic_vector (6 downto 0);
		   data_in : in std_logic_vector(7 downto 0);
			data_out: out std_logic_vector(7 downto 0));
	end component;
	
	component mem_prog is 
	port( clk : in std_logic;
			address  : in std_logic_vector (6 downto 0);
			data_out: out std_logic_vector(7 downto 0));
	end component;
	
	component puertos_salida is 
	port( clk, rst, wr : in std_logic;
			address      : in std_logic_vector (3 downto 0);
		   data_in      : in std_logic_vector(7 downto 0);
			p_out_00, p_out_01, p_out_02, p_out_03 : out std_logic_vector(7 downto 0);
			p_out_04, p_out_05, p_out_06, p_out_07 : out std_logic_vector(7 downto 0);
			p_out_08, p_out_09, p_out_10, p_out_11 : out std_logic_vector(7 downto 0);
			p_out_12, p_out_13, p_out_14, p_out_15 : out std_logic_vector(7 downto 0));
	end component;
	
	-- declaramos las señales necesarias
	signal output_port_addr : std_logic_vector(3 downto 0);
	signal rom_out, ram_out : std_logic_vector(7 downto 0);
	signal ram_address, rom_address : std_logic_vector(6 downto 0);

	begin
		
		rom_address <= address (6 downto 0) when (address(7)= '0') else "0000000";
		ram_address <= address (6 downto 0) when (address(7)= '1') else "0000000";
		output_port_addr <= address (3 downto 0) when (address(7 downto 4)= x"F") else "0000";
		
		-- Instancia de mem_datos
		mem_dato : mem_datos port map (clk, wr, ram_address, data_in, ram_out);
		-- Instancia de mem_prog
		mem_progra : mem_prog port map (clk, rom_address, rom_out);
		-- Instancia de puertos_salida
		Puertos : puertos_salida port map (clk, rst, wr, output_port_addr, data_in,
				p_out_00, p_out_01, p_out_02, p_out_03,
				p_out_04, p_out_05, p_out_06, p_out_07,
				p_out_08, p_out_09, p_out_10, p_out_11,
				p_out_12, p_out_13, p_out_14, p_out_15);

		-- Mux de salida
		data_out <= rom_out when address < x"80" else
						ram_out when address < x"E0" else
						p_in_00 when address = x"E0" else
						p_in_01 when address = x"E1" else
						p_in_02 when address = x"E2" else
						p_in_03 when address = x"E3" else
						p_in_04 when address = x"E4" else
						p_in_05 when address = x"E5" else
						p_in_06 when address = x"E6" else
						p_in_07 when address = x"E7" else
						p_in_08 when address = x"E8" else
						p_in_09 when address = x"E9" else
						p_in_10 when address = x"EA" else
						p_in_11 when address = x"EB" else
						p_in_12 when address = x"EC" else
						p_in_13 when address = x"ED" else
						p_in_14 when address = x"EE" else
						p_in_15 when address = x"EF" else
						(others => '0'); 

end architecture;

