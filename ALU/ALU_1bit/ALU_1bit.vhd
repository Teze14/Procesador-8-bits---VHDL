-- Jesus Emiliano García Jiménez 
-- A01751766
-- Archivo ALU bit-slice 1 bit

-- Archivo ALU bit-slice 1 bit corregido

library ieee;
use ieee.std_logic_1164.all;

entity ALU_1bit is 
    port(
        A, B      : in std_logic;
        NA, NB    : in std_logic;
        Cin       : in std_logic;
        Sel       : in std_logic_vector(3 downto 0); -- Selección de operación
        S         : out std_logic;
        Co        : out std_logic
    );
end entity;

architecture RTL of ALU_1bit is

    -- Componente Half Adder
    component HA is 
        port(
            A, B : in std_logic;
            S, Co: out std_logic
        );
    end component;

    -- Señales internas
    signal A_mod, B_mod, Ci_s        : std_logic;
    signal sum1, sum2, c1, c2        : std_logic;
    signal op_add, op_sub, op_and, op_or, op_xor : std_logic;
    signal op_inc_a, op_inc_b, op_dec_a, op_dec_b, op_not_a, op_not_b : std_logic;
    signal and_out, or_out, xor_out, sum_out : std_logic;
    signal not_a_out, not_b_out     : std_logic;

begin

    -- Aplicar inversión condicional a A y B
    A_mod <= A xor NA;
    B_mod <= B xor NB;
    Ci_s  <= Cin;  -- Cin ya debe estar controlado desde el módulo superior

    -- Half Adders
    HA1: HA port map (A_mod, B_mod, sum1, c1);
    HA2: HA port map (sum1, Ci_s, sum2, c2);
    Co <= c1 or c2;

    -- Decodificación de operaciones
    op_add    <= '1' when Sel = "0000" else '0';
    op_sub    <= '1' when Sel = "0001" else '0';
    op_and    <= '1' when Sel = "0010" else '0';
    op_or     <= '1' when Sel = "0011" else '0';
    op_xor    <= '1' when Sel = "0100" else '0';
    op_inc_a  <= '1' when Sel = "0101" else '0';
    op_inc_b  <= '1' when Sel = "0110" else '0';
    op_dec_a  <= '1' when Sel = "0111" else '0';
    op_dec_b  <= '1' when Sel = "1000" else '0';
    op_not_a  <= '1' when Sel = "1001" else '0';
    op_not_b  <= '1' when Sel = "1010" else '0';

    -- Operaciones lógicas
    and_out <= A_mod and B_mod;
    or_out  <= A_mod or  B_mod;
    xor_out <= A_mod xor B_mod;

    -- Operaciones aritméticas
    sum_out <= sum2 when (op_add or op_sub or op_inc_a or op_inc_b or op_dec_a or op_dec_b) = '1'
               else '0';

    -- Negaciones
    not_a_out <= not A_mod;
    not_b_out <= not B_mod;

    -- MUX de salida
    S <= (and_out and op_and) or
         (or_out  and op_or)  or
         (xor_out and op_xor) or
         (sum_out and (op_add or op_sub or op_inc_a or op_inc_b or op_dec_a or op_dec_b)) or
         (not_a_out and op_not_a) or
         (not_b_out and op_not_b);

end architecture;


