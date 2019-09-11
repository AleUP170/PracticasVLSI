LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY sistemaBombas IS
PORT(
	CLK, SENSOR: IN std_logic;
	LEDS: OUT std_logic_vector(1 downto 0)
);
END sistemaBombas;

ARCHITECTURE prac3 OF sistemaBombas IS
	TYPE ROM IS ARRAY (3 DOWNTO 0) OF std_logic_vector(1 downto 0);
	SIGNAL STATE: ROM:= 	("00", --Memoria ROM que guarda las salidas de los estados
								"10",
								"00",
								"01");
	SIGNAL EDOPRES: integer := 0;
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
shift:	PROCESS(EDOPRES) -- Proceso del Rregistro de corrimiento
	BEGIN
		IF RISING_EDGE(DIVFREC) THEN -- Maquina mealy
			IF EDOPRES = 0 THEN 			-- Primer estado
				IF SENSOR = '1' THEN
					EDOPRES <= 1;
				ELSE
					EDOPRES <= 0;
				END IF;
			ELSIF EDOPRES = 1 THEN 	-- Segundo estado
				IF SENSOR = '1' THEN
					EDOPRES <= 1;
				ELSE
					EDOPRES <= 2;
				END IF;
			ELSIF EDOPRES = 2 THEN	-- Tercer estado
				IF SENSOR = '1' THEN
					EDOPRES <= 3;
				ELSE
					EDOPRES <= 2;
				END IF;
			ELSIF EDOPRES = 3 THEN 	-- Cuarto estado
				IF SENSOR = '1' THEN
					EDOPRES <= 3;
				ELSE
					EDOPRES <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	LEDS <= STATE(EDOPRES);		
END prac3;