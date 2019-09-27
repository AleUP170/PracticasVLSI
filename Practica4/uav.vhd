LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY uav IS
PORT(
	CLK, RESET, Sd, Si: IN std_logic;
	EDOS: OUT std_logic_vector(7 downto 0); -- Para el display de 7 seg
	DIRS: OUT std_logic_vector(3 downto 0) -- Direcciones del dron (Adelante, atrás, giro izq, giro der)
);
END uav;

ARCHITECTURE prac4 OF uav IS
	TYPE ROM IS ARRAY (0 TO 15) OF std_logic_vector(7 downto 0); --Memoria ROM que guarda las salidas para el display de 7 segmentos
	SIGNAL DISP7SEG: ROM:= 	("11000000",  --0
									 "11111001",  --1
									 "10100100",  --2
									 "10110000",  --3
									 "10011001",  --4
									 "10010010",  --5
									 "10000010",  --6
									 "11111000",  --7
									 "10000000",  --8
									 "10010000",  --9
									 "10001000",  --A
									 "10000011",  --B
									 "11000110",  --C
									 "10100001",  --D
									 "10000110",  --E
									 "10001110"); --F
	TYPE ESTADOS IS (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11);
	SIGNAL EDO_PRES, EDO_SIG: ESTADOS := S0;
	SIGNAL SIGDIRS: std_logic_vector(3 downto 0);
	SIGNAL DISPLAY: integer := 0;
	SIGNAL DIVFREC: std_logic := '0';
	SIGNAL CONDIVFREC: integer:= 0;
BEGIN
div:	PROCESS(DIVFREC, CONDIVFREC) -- Proceso del divisor de frecuencias
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CONDIVFREC <= CONDIVFREC + 1; 	-- La DE10 Lite usa un reloj con frecuencia de 50 MHz
			IF CONDIVFREC = 24999999 THEN 	-- Para obtener una señal de 1 Hz, se tiene que hacer un contador
				DIVFREC <= NOT DIVFREC;		-- Hasta (50 MHz/2 - 1), igual a 24999999
				CONDIVFREC <= 0;
			END IF;
		END IF;
	END PROCESS;
ASM:	PROCESS(EDO_SIG, SIGDIRS, DISPLAY) -- Proceso de manejo de estados
	BEGIN
		IF RESET = '0' THEN
				EDO_PRES <= s0;
				EDO_SIG <= S0;
				SIGDIRS <= "0000";
				DISPLAY <= 0;
		ELSE
			EDO_PRES <= EDO_SIG;
			IF RISING_EDGE(DIVFREC) THEN
				CASE EDO_PRES IS
					WHEN S0 =>
						IF Si = '0' THEN
							IF Sd = '0' THEN
								SIGDIRS <= "1000";
								EDO_SIG <= S0;
							ELSE
								SIGDIRS <= "0000";
								EDO_SIG <= S1;
							END IF;
						ELSE
							IF Sd <= '0' THEN
								SIGDIRS <= "0000";
								EDO_SIG <= S3;
							ELSE
								SIGDIRS <= "0000";
								EDO_SIG <= S5;
							END IF;
						END IF;
						DISPLAY <= 0;
					WHEN S1 =>
						SIGDIRS <= "0100";
						EDO_SIG <= S2;
						DISPLAY <= 1;
					WHEN S2 =>
						SIGDIRS <= "0010";
						EDO_SIG <= S0;
						DISPLAY <= 2;
					WHEN S3 =>
						SIGDIRS <= "0100";
						EDO_SIG <= S4;
						DISPLAY <= 3;
					WHEN S4 =>
						SIGDIRS <= "0001";
						EDO_SIG <= S0;
						DISPLAY <= 4;
					WHEN S5 =>
						SIGDIRS <= "0100";
						EDO_SIG <= S6;
						DISPLAY <= 5;
					WHEN S6 =>
						SIGDIRS <= "0010";
						EDO_SIG <= S7;
						DISPLAY <= 6;
					WHEN S7 =>
						SIGDIRS <= "0010";
						EDO_SIG <= S8;
						DISPLAY <= 7;
					WHEN S8 =>
						SIGDIRS <= "1000";
						EDO_SIG <= S9;
						DISPLAY <= 8;
					WHEN S9 =>
						SIGDIRS <= "1000";
						EDO_SIG <= S10;
						DISPLAY <= 9;
					WHEN S10 =>
						SIGDIRS <= "0001";
						EDO_SIG <= S11;
						DISPLAY <= 10;
					WHEN S11 =>
						SIGDIRS <= "0001";
						EDO_SIG <= S0;
						DISPLAY <= 11;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	EDOS <= 	DISP7SEG(0) WHEN RESET = '0' ELSE
				DISP7SEG(DISPLAY);
	DIRS <= 	"0000" WHEN RESET = '0' ELSE
				SIGDIRS;	
END prac4;