-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo Memoria de Programa ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mem_prog is 
	port( clk : in std_logic;
			address  : in std_logic_vector (6 downto 0);
			data_out: out std_logic_vector(7 downto 0));
end entity;

architecture RTL of mem_prog is

	-- Instruction Set Architecture
	-- Transferencia de datos
	constant LOAD_INM_A  : STD_LOGIC_VECTOR(7 downto 0) := x"86"; -- Carga inmediata en A
	constant LOAD_INM_B  : STD_LOGIC_VECTOR(7 downto 0) := x"87"; -- Carga inmediata en B
	constant LOAD_DIR_A  : STD_LOGIC_VECTOR(7 downto 0) := x"88"; -- Carga dirección en A
	constant LOAD_DIR_B  : STD_LOGIC_VECTOR(7 downto 0) := x"89"; -- Carga dirección en B
	constant STORE_A     : STD_LOGIC_VECTOR(7 downto 0) := x"96"; -- Guarda A en dirección
	constant STORE_B     : STD_LOGIC_VECTOR(7 downto 0) := x"97"; -- Guarda B en dirección

	-- Operaciones Aritmético-Lógicas
	constant ADD_AB      : STD_LOGIC_VECTOR(7 downto 0) := x"40"; -- Suma A + B
	constant SUB_AB      : STD_LOGIC_VECTOR(7 downto 0) := x"41"; -- Resta A - B
	constant AND_AB      : STD_LOGIC_VECTOR(7 downto 0) := x"42"; -- A AND B
	constant OR_AB       : STD_LOGIC_VECTOR(7 downto 0) := x"43"; -- A OR B
	constant XOR_AB      : STD_LOGIC_VECTOR(7 downto 0) := x"44"; -- A XOR B
	constant INC_A       : STD_LOGIC_VECTOR(7 downto 0) := x"45"; -- INC A = A+1
	constant INC_B       : STD_LOGIC_VECTOR(7 downto 0) := x"46"; -- INC B = B+1
	constant DEC_A       : STD_LOGIC_VECTOR(7 downto 0) := x"47"; -- DEC A = A-1
	constant DEC_B       : STD_LOGIC_VECTOR(7 downto 0) := x"48"; -- DEC B = B-1
	constant NOT_A       : STD_LOGIC_VECTOR(7 downto 0) := x"50"; -- NEG A => Compl A
	constant NOT_B       : STD_LOGIC_VECTOR(7 downto 0) := x"51"; -- NEG B => Compl B

	-- Saltos
	constant JMP         : STD_LOGIC_VECTOR(7 downto 0) := x"20"; -- Salto incondicional a dirección
	constant JN          : STD_LOGIC_VECTOR(7 downto 0) := x"21"; -- Salto a dirección si N=1
	constant JNN         : STD_LOGIC_VECTOR(7 downto 0) := x"22"; -- Salto a dirección si N=0 
	constant JZ          : STD_LOGIC_VECTOR(7 downto 0) := x"23"; -- Salto a dirección si Z=1 /JE
	constant JNZ         : STD_LOGIC_VECTOR(7 downto 0) := x"24"; -- Salto a dirección si Z=0 / JNE
	constant JOV         : STD_LOGIC_VECTOR(7 downto 0) := x"25"; -- Salto a dirección si V=1
	constant JNOV        : STD_LOGIC_VECTOR(7 downto 0) := x"26"; -- Salto a dirección si V=0
	constant JC          : STD_LOGIC_VECTOR(7 downto 0) := x"27"; -- Salto a dirección si C=1
	constant JNC         : STD_LOGIC_VECTOR(7 downto 0) := x"28"; -- Salto a dirección si C=0

	
	type instmem is array (0 to 127) of std_logic_vector (7 downto 0);
	
	-- declaramos las señales necesarias
signal ROM: instmem := (
									 0 => x"86",  -- LOAD_INM_A
									 1 => x"03",  -- Valor Inmediato: 3 (Precargado en A)
									 2 => x"89",  -- LOAD_DIR_B
									 3 => x"E0",  -- Dirección del puerto de entrada 1
									 4 => x"40",  -- ADD_AB
									 5 => x"96",  -- STORE_A
									 6 => x"F0",  -- Dirección del puerto de salida 0
									 others => x"00"
								);




	
	begin
	process(clk)
			begin
				if (clk'event and clk='1') then
					data_out <= ROM (conv_integer(unsigned(address)));
				end if;
	end process;
end architecture;

