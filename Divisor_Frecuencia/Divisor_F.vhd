library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Divisor_F is
    port(
        clk_in  : in std_logic;
        rst     : in std_logic;
        clk_out : out std_logic
    );
end entity;

architecture RTL of Divisor_F is
    constant MAX_COUNT : integer := 25_000_000; -- Para 1 Hz con 50 MHz
    signal count : integer range 0 to MAX_COUNT := 0;
    signal clk_div : std_logic := '0';
begin
    process(clk_in, rst)
    begin
        if rst = '1' then
            count <= 0;
            clk_div <= '0';
        elsif rising_edge(clk_in) then
            if count = MAX_COUNT - 1 then
                count <= 0;
                clk_div <= not clk_div;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_div;
end architecture;
