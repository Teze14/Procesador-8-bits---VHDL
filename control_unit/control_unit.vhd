library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port ( clk, rst                            : in std_logic;
			 CCR_Result                          : in std_logic_vector (3 downto 0);
			 IR                                  : in std_logic_vector (7 downto 0);
			 A_Load, B_Load, CCR_Load            : out std_logic;
			 IR_Load, MAR_Load, PC_Load, PC_Inc  : out std_logic;
			 ALU_Sel                             : out std_logic_vector (3 downto 0);
			 Bus1_Sel, Bus2_Sel                  : out std_logic_vector (1 downto 0);
			 wr                                  : out std_logic);
end entity;

architecture RTL of control_unit is
	
	Type FSM is ( IDLE, 
						Fetch0, Fetch1, Fetch2, DS,
						Op86A, Op86B, Op86C,       				--LOAD_INM_A
						Op87A, Op87B, Op87C,							--LOAD_INM_B
						Op88A, Op88B, Op88C, Op88D, Op88E,		--LOAD_DIR_A
						Op89A, Op89B, Op89C, Op89D, Op89E,		--LOAD_DIR_B
						Op96A, Op96B, Op96C, Op96D,				--STORE_A
						Op97A, Op97B, Op97C, Op97D,				--STORE_B
						Op40,												--ADD_AB
						Op41,												--SUB_AB
						Op42,												--AND_AB
						Op43,												--OR_AB
						Op44,												--XOR_AB
						
						Op45,												--INC_A
						Op46,												--INC_B
						Op47,												--DEC_A
						Op48,												--DEC_B
						Op50,												--NOT_A
						Op51,												--NOT_B
						
						Op20, Op20A, Op20B,							--JMP
						Op21, Op21A, Op21B, Op21C,             -- JN
						Op22, Op22A, Op22B, Op22C,            	-- JNN
						Op23, Op23A, Op23B, Op23C,            	-- JZ
						Op24, Op24A, Op24B, Op24C,           	-- JNZ
						Op25, Op25A, Op25B, Op25C,           	-- JOV
						Op26, Op26A, Op26B, Op26C,           	-- JNOV
						Op27, Op27A, Op27B, Op27C,           	-- JC
						Op28, Op28A, Op28B, Op28C           	-- JNC
	
	);
	
	
	signal EDO, EDOF : FSM;
	signal N, Z, O, C: std_logic;
	
	begin	
		N <= CCR_Result(3); -- BANDERA NEGATIVO
		Z <= CCR_Result(2); -- BANDERA CERO
		O <= CCR_Result(1); -- BANDERA OVERFLOW
		C <= CCR_Result(0); -- BANDERA CARRY

		
		P1: process (clk, rst)
        begin
			  if (rst = '1') then
					EDO <= IDLE;
			  elsif (rising_edge(clk)) then
					EDO <= EDOF;
			  end if;
      end process;
		
		P2 : process(clk, EDO, IR, CCR_Result)
			begin 
				case EDO is 
				   ------Estados principales------
					when  IDLE => EDOF <= Fetch0;
					when  Fetch0 => EDOF <= Fetch1;					
					when  Fetch1 => EDOF <= Fetch2;
					when 	Fetch2 => EDOF <= DS;
			
					               ------Load_in-------
					when  DS    => if (IR = x"86") then
							            EDOF <= Op86A;
										elsif (IR = x"87") then
							            EDOF <= Op87A;
										------Load_direccion------
										elsif (IR = x"88") then
							            EDOF <= Op88A;
										elsif (IR = x"89") then
							            EDOF <= Op89A;
										------Store------
										elsif (IR = x"96") then
							            EDOF <= Op96A;
										elsif (IR = x"97") then
							            EDOF <= Op97A;
											
										--------Operaciones aritmeticas logicas--------
										----Suma A+B----
										elsif (IR = x"40") then
											EDOF <= Op40;
										----resta A-B----
										elsif (IR = x"41") then
											EDOF <= Op41;
										----A and B	-----
										elsif (IR = x"42") then
											EDOF <= Op42;
										----A or B ------
										elsif (IR = x"43") then
											EDOF <= Op43;
										----A xor B -----
										elsif (IR = x"44") then
											EDOF <= Op44;
										----incremento en A -----
										elsif (IR = x"45") then
											EDOF <= Op45;
										----incremento en B -----
										elsif (IR = x"46") then
											EDOF <= Op46;
										----decremento en A ------	
										elsif (IR = x"47") then
											EDOF <= Op47;
										----decremento en B ------
										elsif (IR = x"48") then
											EDOF <= Op48;
										-----not en A ----
										elsif (IR = x"50") then
											EDOF <= Op50;
										-----not en B -----
										elsif (IR = x"51") then
											EDOF <= Op51;
										
										--------Saltos--------
										elsif (IR = x"21") then 
											if (N = '0') then
												EDOF <= Op21; -- N = 0
											else
												EDOF <= Op21A; -- N = 1
											end if;
										elsif (IR = x"22") then 
											if (N = '0') then
												EDOF <= Op22; -- N = 0
											else
												EDOF <= Op22A; -- N = 1
											end if;
										
										elsif (IR = x"23") then 
											if (Z = '0') then
												EDOF <= Op23; -- Z = 0
											else
												EDOF <= Op23A; -- Z = 1
											end if;
										elsif (IR = x"24") then 
											if (Z = '0') then
												EDOF <= Op24; -- Z = 0
											else
												EDOF <= Op24A; -- Z = 1
											end if;
										
										elsif (IR = x"25") then 
											if (O = '0') then
												EDOF <= Op25; -- O = 0
											else
												EDOF <= Op25A; -- O = 1
											end if;
										elsif (IR = x"26") then 
											if (O = '0') then
												EDOF <= Op26; -- O = 0
											else
												EDOF <= Op26A; -- O = 1
											end if;
										
										elsif (IR = x"27") then 
											if (C = '0') then
												EDOF <= Op27; -- C = 0
											else
												EDOF <= Op27A; -- C = 1
											end if;
										elsif (IR = x"28") then 
											if (C = '0') then
												EDOF <= Op28; -- C = 0
											else
												EDOF <= Op28A; -- C = 1
											end if;
									   else
											EDOF <= IDLE;
					               end if;
					
					----suma de A + B-----
					when  Op40 => 
							EDOF <= IDLE;
					
					-----resta de A-B ------
					when  Op41 => 
							EDOF <= IDLE;
					
					----- A and B ------
					when  Op42 => 
							EDOF <= IDLE;
					
					---- A or B ------
					when  Op43 => 
							EDOF <= IDLE;
					
					---- A xor B -----
					when  Op44 => 
							EDOF <= IDLE;
					
					----incremento en A ----
					when  Op45 => 
							EDOF <= IDLE;
					
					-----incremento en B ----
					when  Op46 => 
							EDOF <= IDLE;
					
					-----decremento en A -----
					when  Op47 => 
							EDOF <= IDLE;
					
					-----decremento en B -----
					when  Op48 => 
							EDOF <= IDLE;
							
					----- NOT A -----
					when  Op50 => 
							EDOF <= IDLE;
					
					-----NOT B -----
					when  Op51 => 
							EDOF <= IDLE;
							
		------------------------------------------------------------------------------------------------------	
					----- Load_inmA -----
					when  Op86A => 
							EDOF <= Op86B;	
					when  Op86B =>
							EDOF <= Op86C;
					when  Op86C =>
							EDOF <= IDLE ; 
					-----Load_inmB -----
					when  Op87A => 
							EDOF <= Op87B;	
					when  Op87B =>
							EDOF <= Op87C;
					when  Op87C =>
							EDOF <= IDLE ; 

		------------------------------------------------------------------------------------------------------

					----- Load_DIR_A -----
					when  Op88A => 
							EDOF <= Op88B;	
					when  Op88B =>
							EDOF <= Op88C;
					when  Op88C =>
							EDOF <= Op88D ;
					when  Op88D => 
							EDOF <= Op88E;	
					when  Op88E =>
							EDOF <= IDLE;
					----- Load_DIR_B -----
					when  Op89A => 
							EDOF <= Op89B;	
					when  Op89B =>
							EDOF <= Op89C;
					when  Op89C =>
							EDOF <= Op89D ;
					when  Op89D => 
							EDOF <= Op89E;	
					when  Op89E =>
							EDOF <= IDLE;
					

		------------------------------------------------------------------------------------------------------

					----- STORE_A -----
					when  Op96A => 
							EDOF <= Op96B;	
					when  Op96B =>
							EDOF <= OP96C;
					when  Op96C =>
							EDOF <= Op96D ;
					when  Op96D => 
							EDOF <= IDLE;
					----- STORE_B -----
					when  Op97A => 
							EDOF <= Op97B;	
					when  Op97B =>
							EDOF <= OP97C;
					when  Op97C =>
							EDOF <= Op97D ;
					when  Op97D => 
							EDOF <= IDLE;	
						
					
		------------------------------------------------------------------------------------------------------	
					---- SALTO INCondicional 
					when  Op20 =>
							EDOF <= Op20A;	
					when  Op20A =>
							EDOF <= Op20B;	
					when  Op20B => 
							EDOF <= IDLE;
					
		------------------------------------------------------------------------------------------------------
					---- Salto condicional JN
					when  Op21 => 
							EDOF <= IDLE;
					when  Op21A => 
							EDOF <= Op21B;
					when  Op21B => 
							EDOF <= Op21C ;       	
					when  Op21C => 
							EDOF <= IDLE ;
		------------------------------------------------------------------------------------------------------		
					----Salto condicional JNN---- 
					when  Op22 => 
							EDOF <= IDLE;
					when  Op22A => 
							EDOF <= Op22B;
					when  Op22B => 
							EDOF <= Op22C ;       	
					when  Op22C => 
							EDOF <= IDLE ;
		------------------------------------------------------------------------------------------------------		
					---- Salto condicional JZ----
					when  Op23 => 
							EDOF <= IDLE;
					when  Op23A => 
							EDOF <= Op23B;
					when  Op23B => 
							EDOF <= Op23C ;       	
					when  Op23C => 
							EDOF <= IDLE ;
		------------------------------------------------------------------------------------------------------	
					----- Salto condicional JNZ -----
					when  Op24 => 
							EDOF <= IDLE;
					when  Op24A => 
							EDOF <= Op24B;
					when  Op24B => 
							EDOF <= Op24C ;       	
					when  Op24C => 
							EDOF <= IDLE ;
		------------------------------------------------------------------------------------------------------
					----- Salto condicional JOV -----
					when  Op25 => 
							EDOF <= IDLE;
					when  Op25A => 
							EDOF <= Op25B;
					when  Op25B => 
							EDOF <= Op25C;       	
					when  Op25C => 
							EDOF <= IDLE;
						
		------------------------------------------------------------------------------------------------------	
					---- Salto condicional JNOV ----
					when  Op26 => 
							EDOF <= IDLE;
					when  Op26A => 
							EDOF <= Op26B;
					when  Op26B => 
							EDOF <= Op26C;       	
					when  Op26C => 
							EDOF <= IDLE;
		------------------------------------------------------------------------------------------------------
					----Salto condicional JC
					when  Op27 => 
							EDOF <= IDLE;
					when  Op27A => 
							EDOF <= Op27B;
					when  Op27B => 
							EDOF <= Op27C;       	
					when  Op27C => 
							EDOF <= IDLE;
		------------------------------------------------------------------------------------------------------										
					----Salto condiconal JNC
					when  Op28 => 
							EDOF <= IDLE;
					when  Op28A => 
							EDOF <= Op28B;
					when  Op28B => 
							EDOF <= Op28C;       	
					when  Op28C => 
							EDOF <= IDLE;	
					when others => null;
				end case;
		end process;
		
		P3: process(clk, EDO)
		 begin
        case EDO is 
            -- Estados principales
            when IDLE =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Fetch0 =>
                IR_Load <= '0';
                MAR_Load <= '1';  -- Cargar MAR con el valor del PC
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Fetch1 =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Fetch2 =>
                IR_Load <= '1';    -- Cargar IR con dato de memoria
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            when DS =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            -- LOAD_INM_A (Op86)
            when Op86A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC (para leer el operando)
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01"; -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op86B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op86C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar A con el dato inmediato
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10"; -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- LOAD_INM_B (Op87)
            when Op87A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01"; -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op87B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';    -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op87C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';    -- Cargar B con el dato inmediato
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- LOAD_DIR_A (Op88)
            when Op88A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer la dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op88B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op88C =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con la dirección de memoria
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2 (dirección)
                wr <= '0';
                
            when Op88D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op88E =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar A con dato de memoria
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2 (dato)
                wr <= '0';
                
            -- LOAD_DIR_B (Op89) - Similar a LOAD_DIR_A pero carga B
            when Op89A =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op89B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op89C =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            when Op89D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op89E =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';     -- Cargar B con dato de memoria
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- STORE_A (Op96)
            when Op96A =>
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";   -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op96B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';      -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op96C =>
                IR_Load <= '0';
                MAR_Load <= '1';    -- Cargar MAR con dirección de memoria
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";  -- Seleccionar memoria en Bus2
                wr <= '0';
                
            when Op96D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "01";  -- Seleccionar A en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '1';         -- Escribir en memoria
                
            -- STORE_B (Op97) - Similar a STORE_A pero con B
            when Op97A =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op97B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op97C =>
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            when Op97D =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "10";  -- Seleccionar B en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '1';         -- Escribir en memoria
                
            -- Operaciones ALU
            when Op40 =>  -- ADD_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';     -- Cargar resultado en A
                B_Load <= '0';
                ALU_Sel <= "0001"; -- Seleccionar operación de suma
                CCR_Load <= '1';   -- Actualizar banderas
                Bus1_Sel <= "01";  -- Seleccionar A en Bus1
                Bus2_Sel <= "11";  -- Seleccionar ALU en Bus2
                wr <= '0';
                
            when Op41 =>  -- SUB_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0010"; -- Seleccionar operación de resta
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op42 =>  -- AND_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0011"; -- AND
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op43 =>  -- OR_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0100"; -- OR
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op44 =>  -- XOR_AB
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0101"; -- XOR
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op45 =>  -- INC_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0110"; -- Incremento
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op46 =>  -- INC_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "0110"; -- Incremento
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op47 =>  -- DEC_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "0111"; -- Decremento
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op48 =>  -- DEC_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "0111"; -- Decremento
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op50 =>  -- NOT_A
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '1';
                B_Load <= '0';
                ALU_Sel <= "1000"; -- NOT
                CCR_Load <= '1';
                Bus1_Sel <= "01";
                Bus2_Sel <= "11";
                wr <= '0';
                
            when Op51 =>  -- NOT_B
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '1';
                ALU_Sel <= "1000"; -- NOT
                CCR_Load <= '1';
                Bus1_Sel <= "10";
                Bus2_Sel <= "11";
                wr <= '0';
                
            -- Saltos incondicionales
            when Op20 =>  -- JMP
                IR_Load <= '0';
                MAR_Load <= '1';   -- Cargar MAR con PC para leer dirección de salto
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";  -- Seleccionar PC en Bus1
                Bus2_Sel <= "01";  -- Seleccionar Bus1 en Bus2
                wr <= '0';
                
            when Op20A =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';     -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op20B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';     -- Cargar PC con dirección de salto
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";   -- Seleccionar memoria en Bus2
                wr <= '0';
                
            -- Saltos condicionales (todos siguen el mismo patrón)
            -- JN (Op21)
            when Op21 =>  -- No se toma el salto (N=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';      -- Solo incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op21A =>  -- Se toma el salto (N=1)
                IR_Load <= '0';
                MAR_Load <= '1';    -- Cargar MAR con PC para leer dirección
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op21B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';      -- Incrementar PC
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op21C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';     -- Cargar PC con dirección de salto
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNN (Op22) - Similar a JN pero condiciones invertidas
            when Op22 =>  -- No se toma el salto (N=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op22A =>  -- Se toma el salto (N=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op22B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op22C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JZ (Op23)
            when Op23 =>  -- No se toma el salto (Z=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op23A =>  -- Se toma el salto (Z=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op23B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op23C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNZ (Op24) - Similar a JZ pero condiciones invertidas
            when Op24 =>  -- No se toma el salto (Z=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op24A =>  -- Se toma el salto (Z=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op24B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op24C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JOV (Op25)
            when Op25 =>  -- No se toma el salto (O=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op25A =>  -- Se toma el salto (O=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op25B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op25C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNOV (Op26) - Similar a JOV pero condiciones invertidas
            when Op26 =>  -- No se toma el salto (O=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op26A =>  -- Se toma el salto (O=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op26B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op26C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JC (Op27)
            when Op27 =>  -- No se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op27A =>  -- Se toma el salto (C=1)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "01";
                wr <= '0';
                
            when Op27B =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op27C =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "10";
                wr <= '0';
                
            -- JNC (Op28) - Similar a JC pero condiciones invertidas
            when Op28 =>  -- No se toma el salto (C=1)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '1';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
                
            when Op28A =>  -- Se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '1';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
					 Bus2_Sel <= "01";
					 wr <= '0';
					 
				when Op28B =>  -- Se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
					 Bus2_Sel <= "00";
					 wr <= '0';
					 
				when Op28C =>  -- Se toma el salto (C=0)
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '1';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
					 Bus2_Sel <= "10";
					 wr <= '0';
					 
				when others =>
                IR_Load <= '0';
                MAR_Load <= '0';
                PC_Load <= '0';
                PC_Inc <= '0';
                A_Load <= '0';
                B_Load <= '0';
                ALU_Sel <= "0000";
                CCR_Load <= '0';
                Bus1_Sel <= "00";
                Bus2_Sel <= "00";
                wr <= '0';
        end case;
    end process;
end architecture;