--Jesús Emiliano García Jiménez
--A01751766
--Data Path del Procesador


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity data_path is 
	port( clk, rst, IR_Load, MAR_Load, PC_Load, Ci     : in std_logic;
	      PC_Inc, A_Load, B_Load, CCR_Load, NA, NB     : in std_logic;
			ALU_Sel                              : in std_logic_vector (3 downto 0);
			Bus1_Sel, Bus2_Sel                   : in std_logic_vector (1 downto 0);
			from_memory                          : in std_logic_vector (7 downto 0);
			IR, address, to_memory  : out std_logic_vector (7 downto 0);
			CCR_Result              : out std_logic_vector (3 downto 0));
end entity;

architecture RTL of data_path is
	
	component ALU_8bits is 
		port( A, B   : in std_logic_vector(7 downto 0);
				NA, NB : in std_logic;
				Ci     : in std_logic;
				Sel    : in  std_logic_vector(3 downto 0);
				Suma   : out std_logic_vector(7 downto 0);
				flags  : out std_logic_vector(3 downto 0));
	end component;
	
	-- declaramos las señales necesarias
	signal  BUS1, BUS2, ALU_Result        : std_logic_vector (7 downto 0);
	signal  IR_Reg, MAR, PC, A_Reg, B_Reg : std_logic_vector (7 downto 0);
	signal CCR_in, CCR                    : std_logic_vector (3 downto 0);
	--signal NA, NB, Ci, Co                 : std_logic;
	
	begin
		-----Registro A-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				A_Reg <= x"00";
			elsif (clk'event and clk = '1') then
				if (A_Load = '1') then
					A_Reg <= BUS2;
				end if;
			end if;
		end process;
		
		-----Registro B-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				B_Reg <= x"00";
			elsif (clk'event and clk = '1') then
				if (B_Load = '1') then
					B_Reg <= BUS2;
				end if;
			end if;
		end process;
		
		-----Instruction Register-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				IR_Reg <= x"00";
			elsif (clk'event and clk = '1') then
				if (IR_Load = '1') then
					IR_Reg <= BUS2;
				end if;
			end if;
		end process;
		
		-----MAR-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				MAR <= x"00";
			elsif (clk'event and clk = '1') then
				if (MAR_Load = '1') then
					MAR <= BUS2;
				end if;
			end if;
		end process;
		
		-----Program Counter-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				PC <= x"00";
			elsif (clk'event and clk = '1') then
				if (PC_Load = '1') then
					PC <= BUS2;
				elsif (PC_Inc = '1') then
					PC <= PC + x"01";
				end if;
			end if;
		end process;
		
		-----CCR-----
		process (clk, rst)
		begin 
			if (rst = '1') then
				CCR <= x"0";
			elsif (clk'event and clk = '1') then
				if (CCR_Load = '1') then
					CCR <= CCR_in;
				end if;
			end if;
		end process;
		
		-----ALU-----
		ALU_unit : ALU_8bits port map(B_Reg, BUS1, NA, NB, Ci, ALU_Sel, ALU_Result, CCR_in);
		
		-----MUX BUS1-----
		BUS1 <= PC    when Bus1_Sel = "00" else
				  A_Reg when Bus1_Sel = "01" else
				  B_Reg when Bus1_Sel = "10" else
				  x"00";
				  
		-----MUX BUS2-----
		BUS2 <= ALU_Result  when Bus2_Sel = "00" else
				  BUS1        when Bus2_Sel = "01" else
				  from_memory when Bus2_Sel = "10" else
				  ALU_Result;
				  
		IR         <= IR_Reg;
		address    <= MAR;
		CCR_Result <= CCR;
		to_memory  <= BUS1;

end architecture;