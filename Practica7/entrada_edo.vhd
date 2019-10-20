LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY entrada_edo IS
PORT(
	CLK: IN std_logic;
	LEDS: OUT std_logic_vector(5 downto 0); -- Para leds
	SWITCHES: IN std_logic_vector(2 downto 0) -- Direcciones del dron (Adelante, atrás, giro izq, giro der)
);
END entrada_edo;

ARCHITECTURE y OF entrada_edo IS
	SIGNAL data: std_logic_vector(16 downto 0);
	SIGNAL address: std_logic_vector(3 downto 0);
	SIGNAL DIVFREC: std_logic := '0';
	SIGNAL CONDIVFREC: integer:= 0;
BEGIN
	rom:	ENTITY work.myROM
	PORT MAP(
		addr => address,
		data => data
	);
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
maq: PROCESS(address)
	BEGIN
		IF RISING_EDGE(DIVFREC) THEN
			IF data(16 downto 14) = "000" THEN
				address <= data(13 downto 10);
			ELSIF data(16 downto 14) = "001" THEN
				IF SWITCHES(0) = '0' THEN
					address <= data(13 downto 10);
				ELSE
					address <= data(9 downto 6);
				END IF;
			ELSIF data(16 downto 14) = "010" THEN
				IF SWITCHES(1) = '0' THEN
					address <= data(13 downto 10);
				ELSE
					address <= data(9 downto 6);
				END IF;
			ELSIF data(16 downto 14)= "100" THEN
				IF SWITCHES(2) = '0' THEN
					address <= data(13 downto 10);
				ELSE
					address <= data(9 downto 6);
				END IF;
			END IF;
			leds <= data(5 downto 0);
		END IF;
	END PROCESS;
END y;