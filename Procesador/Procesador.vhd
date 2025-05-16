--Jesús Emiliano García Jiménez
--A01751766
--Procesador final

library ieee;
use ieee.std_logic_1164.all;

entity Procesador is
    port(
        clk, rst       : in std_logic;
        p_in_00, p_in_01, p_in_02, p_in_03 : in std_logic_vector(7 downto 0);
        p_in_04, p_in_05, p_in_06, p_in_07 : in std_logic_vector(7 downto 0);
        p_in_08, p_in_09, p_in_10, p_in_11 : in std_logic_vector(7 downto 0);
        p_in_12, p_in_13, p_in_14, p_in_15 : in std_logic_vector(7 downto 0);
        p_out_00, p_out_01, p_out_02, p_out_03 : out std_logic_vector(7 downto 0);
        p_out_04, p_out_05, p_out_06, p_out_07 : out std_logic_vector(7 downto 0);
        p_out_08, p_out_09, p_out_10, p_out_11 : out std_logic_vector(7 downto 0);
        p_out_12, p_out_13, p_out_14, p_out_15 : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of Procesador is
    -- Componentes
    component CPU is 
        port( from_memory   : in std_logic_vector(7 downto 0);
                clk,rst       : in std_logic;
                address, to_memory   : out std_logic_vector(7 downto 0);
                wr                   : out std_logic);
     end component;
    
    component memoria is 
        port(
            clk, rst, wr : in std_logic;
            address : in std_logic_vector(7 downto 0);
            data_in : in std_logic_vector(7 downto 0);
            p_in_00, p_in_01, p_in_02, p_in_03 : in std_logic_vector(7 downto 0);
            p_in_04, p_in_05, p_in_06, p_in_07 : in std_logic_vector(7 downto 0);
            p_in_08, p_in_09, p_in_10, p_in_11 : in std_logic_vector(7 downto 0);
            p_in_12, p_in_13, p_in_14, p_in_15 : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0);
            p_out_00, p_out_01, p_out_02, p_out_03 : out std_logic_vector(7 downto 0);
            p_out_04, p_out_05, p_out_06, p_out_07 : out std_logic_vector(7 downto 0);
            p_out_08, p_out_09, p_out_10, p_out_11 : out std_logic_vector(7 downto 0);
            p_out_12, p_out_13, p_out_14, p_out_15 : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Señales de interconexión
    signal address_s     : std_logic_vector(7 downto 0);
    signal data_to_mem_s : std_logic_vector(7 downto 0);
    signal data_from_mem_s : std_logic_vector(7 downto 0);
    signal wr_s          : std_logic;
    
begin
    -- Instanciación de la CPU
    CPU_inst: CPU port map (data_from_mem_s, clk, rst, address_s, data_to_mem_s, wr_s);
    
    -- Instanciación de la memoria
    MEM_inst: memoria port map (clk, rst, wr_s, address_s, data_to_mem_s,
                              p_in_00, p_in_01, p_in_02, p_in_03,
                              p_in_04, p_in_05, p_in_06, p_in_07,
                              p_in_08, p_in_09, p_in_10, p_in_11,
                              p_in_12, p_in_13, p_in_14, p_in_15,
                              data_from_mem_s,
                              p_out_00, p_out_01, p_out_02, p_out_03,
                              p_out_04, p_out_05, p_out_06, p_out_07,
                              p_out_08, p_out_09, p_out_10, p_out_11,
                              p_out_12, p_out_13, p_out_14, p_out_15);
    
end architecture;