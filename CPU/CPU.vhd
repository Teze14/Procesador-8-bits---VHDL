-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo ALU 8 bits bit-slice

library ieee;
use ieee.std_logic_1164.all;

entity CPU is 
	port( from_memory   : in std_logic_vector(7 downto 0);
			clk,rst       : in std_logic;
		   address, to_memory   : out std_logic_vector(7 downto 0);
			wr                   : out std_logic);
end entity;

architecture RTL of CPU is
	--declaramos componentes
	
	component data_path is 
	port( clk, rst, IR_Load, MAR_Load, PC_Load, Ci     : in std_logic;
	      PC_Inc, A_Load, B_Load, CCR_Load, NA, NB     : in std_logic;
			ALU_Sel                              : in std_logic_vector (3 downto 0);
			Bus1_Sel, Bus2_Sel                   : in std_logic_vector (1 downto 0);
			from_memory                          : in std_logic_vector (7 downto 0);
			IR, address, to_memory  : out std_logic_vector (7 downto 0);
			CCR_Result              : out std_logic_vector (3 downto 0));
	end component;
	
	component control_unit is
	port ( clk, rst                            : in std_logic;
			 CCR_Result                          : in std_logic_vector (3 downto 0);
			 IR                                  : in std_logic_vector (7 downto 0);
			 A_Load, B_Load, CCR_Load            : out std_logic;
			 IR_Load, MAR_Load, PC_Load, PC_Inc  : out std_logic;
			 ALU_Sel                             : out std_logic_vector (3 downto 0);
			 Bus1_Sel, Bus2_Sel                  : out std_logic_vector (1 downto 0);
			 wr                                  : out std_logic);
	end component;
	
	-- declaramos las señales necesarias
	 signal IR_signal      : std_logic_vector(7 downto 0);
    signal CCR_signal     : std_logic_vector(3 downto 0);
    signal A_Load_s      : std_logic;
    signal B_Load_s      : std_logic;
    signal CCR_Load_s    : std_logic;
    signal IR_Load_s     : std_logic;
    signal MAR_Load_s    : std_logic;
    signal PC_Load_s     : std_logic;
    signal PC_Inc_s      : std_logic;
    signal ALU_Sel_s     : std_logic_vector(3 downto 0);
    signal Bus1_Sel_s    : std_logic_vector(1 downto 0);
    signal Bus2_Sel_s    : std_logic_vector(1 downto 0);
    signal NA, NB, Ci    : std_logic := '0';
	
	begin
	
		NA <= '0';
		NB <= '0';
		Ci <= '0';
	
		DP: data_path port map (clk, rst, IR_Load_s, MAR_Load_s, PC_Load_s, Ci, PC_Inc_s, A_Load_s, B_Load_s, CCR_Load_s, NA, NB,
										ALU_Sel_s, Bus1_Sel_s, Bus2_Sel_s, from_memory, IR_signal, address, to_memory, CCR_signal);
										
		CU: control_unit port map (clk, rst, CCR_signal, IR_signal, A_Load_s, B_Load_s, CCR_Load_s,
											IR_Load_s, MAR_Load_s, PC_Load_s, PC_Inc_s, ALU_Sel_s, Bus1_Sel_s, Bus2_Sel_s, wr);
			
			
			

end architecture;

