LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY shiftRegister IS
PORT(
	CLK, RESET, DIR: IN std_logic;
	LEDS: OUT std_logic_vector(7 downto 0)
);
END shiftRegister;

ARCHITECTURE prac2 OF shiftRegister IS
	SIGNAL REGIS: std_logic_vector(7 downto 0) := "10011001";
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
shift:	PROCESS(REGIS) -- Proceso del REGISistro de corrimiento
	BEGIN
		IF RISING_EDGE(DIVFREC) THEN
			IF DIR = '1' THEN -- Derecha
				REGIS <= REGIS(0) & REGIS(7 DOWNTO 1);
			ELSE -- Izquierda
				REGIS <= REGIS(6 DOWNTO 0) & REGIS(7);
			END IF;
		END IF;
		IF RESET = '0' THEN -- Reset (Lógica negada)
			REGIS <= "10011001";
		END IF;
	END PROCESS;
	LEDS <= REGIS;
					
END prac2;