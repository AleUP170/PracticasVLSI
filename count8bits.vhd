LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY count8bits IS
PORT(
	CLK, RESET, ONOFF: IN std_logic;
	COUNT: OUT std_logic_vector(7 downto 0)
);
END count8bits;

ARCHITECTURE prac1 OF count8bits IS
	SIGNAL CON: std_logic_vector(7 downto 0) := "00000000";
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
conta:	PROCESS(CON) -- Proceso del contador
	BEGIN
		IF RISING_EDGE(DIVFREC) THEN
			IF RESET = '0' THEN -- Reinicio (El botón de la DE10Lite usa lógica negativa)
				CON <= "00000000";
			ELSE IF ONOFF = '1' THEN -- Prendido
				IF CON = "11111111" THEN -- Numero máximo
					CON <= "00000000";
				ELSE
					CON <= CON + '1'; -- Siguiente número
				END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	COUNT <= CON;
END prac1;