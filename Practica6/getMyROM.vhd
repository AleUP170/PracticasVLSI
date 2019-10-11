LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY getMyROM IS
PORT(
	CLK: IN std_logic;
	disp: out std_logic_vector(6 downto 0)
);
END getMyROM;

ARCHITECTURE y OF getMyROM IS
	SIGNAL data: std_logic_vector(6 downto 0);
	SIGNAL DIVFREC: integer := 0;
	SIGNAL address: std_logic_vector(3 downto 0);
	SIGNAL CONDIVFREC: integer:= 0;
BEGIN
	disp7:	ENTITY work.myROM
	PORT MAP(
		addr => address,
		data => data
	);
	div:	PROCESS(DIVFREC, CONDIVFREC) -- Proceso del divisor de frecuencias
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CONDIVFREC <= CONDIVFREC + 1; 	-- La DE10 Lite usa un reloj con frecuencia de 50 MHz
			IF CONDIVFREC = 50000000 THEN 	-- Para obtener una señal de 1 Hz, se tiene que hacer un contador
				DIVFREC <= DIVFREC + 1;		-- Hasta (50 MHz/2 - 1), igual a 24999999
				IF DIVFREC > 13 THEN
					DIVFREC <= 0;
				END IF;
				CONDIVFREC <= 0;
			END IF;
		END IF;
		address <= CONV_STD_LOGIC_VECTOR(DIVFREC,4);
	END PROCESS;
	disp <= data;
END y;