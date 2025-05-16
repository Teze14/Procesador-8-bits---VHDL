-- Procesador top-level con divisor de reloj para DE10-Lite

library ieee;
use ieee.std_logic_1164.all;

entity Procesador_fpga is
    port(
        clk_50MHz  : in std_logic;  -- reloj de la DE10-Lite
        rst        : in std_logic;
        p_in_00    : in std_logic_vector(7 downto 0);
        p_out_00   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Structural of Procesador_fpga is

    -- Señales internas
    signal clk_slow     : std_logic;
    signal address      : std_logic_vector(7 downto 0);
    signal to_memory    : std_logic_vector(7 downto 0);
    signal from_memory  : std_logic_vector(7 downto 0);
    signal wr           : std_logic;

    -- Señales de p_in y p_out (solo se usan 1)
    signal dummy_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal dummy_out : std_logic_vector(7 downto 0);

    -- Componentes
    component Divisor_F is
        port(
            clk_in  : in std_logic;
            rst     : in std_logic;
            clk_out : out std_logic
        );
    end component;

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
            p_in_00 : in std_logic_vector(7 downto 0);
            p_in_01, p_in_02, p_in_03, p_in_04, p_in_05, p_in_06, p_in_07 : in std_logic_vector(7 downto 0) := dummy_in;
            p_in_08, p_in_09, p_in_10, p_in_11, p_in_12, p_in_13, p_in_14, p_in_15 : in std_logic_vector(7 downto 0) := dummy_in;
            data_out : out std_logic_vector(7 downto 0);
            p_out_00 : out std_logic_vector(7 downto 0);
            p_out_01, p_out_02, p_out_03, p_out_04, p_out_05, p_out_06, p_out_07 : out std_logic_vector(7 downto 0) := dummy_out;
            p_out_08, p_out_09, p_out_10, p_out_11, p_out_12, p_out_13, p_out_14, p_out_15 : out std_logic_vector(7 downto 0) := dummy_out
        );
    end component;

begin

    -- Divisor de reloj
    CLKDIV: Divisor_F port map(clk_in => clk_50MHz, rst => rst, clk_out => clk_slow);

    -- CPU
    U_CPU: CPU port map(
        from_memory => from_memory,
        clk         => clk_slow,
        rst         => rst,
        address     => address,
        to_memory   => to_memory,
        wr          => wr
    );

    -- Memoria
    U_MEM: memoria port map(
        clk       => clk_slow,
        rst       => rst,
        wr        => wr,
        address   => address,
        data_in   => to_memory,
        p_in_00   => p_in_00,
        data_out  => from_memory,
        p_out_00  => p_out_00
    );

end architecture;
