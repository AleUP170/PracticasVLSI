LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY pwm IS
PORT(
	CLK: IN std_logic;
	DUTY: IN std_logic_vector(3 downto 0);
	LED: OUT std_logic;
	OTHERLEDS: OUT std_logic_vector(8 downto 0)
);
END pwm;

ARCHITECTURE prac5 OF pwm IS
	SIGNAL CONTPWM: integer:= 0;
	SIGNAL LEDAUX: std_logic;
BEGIN
div:	PROCESS(CONTPWM) -- Proceso del divisor de frecuencias
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CONTPWM <= CONTPWM + 1;
			IF CONTPWM = 1000000 THEN
				CONTPWM <= 0;
			END IF;
		END IF;
	END PROCESS;
pw:	PROCESS(LEDAUX)
	BEGIN
		--IF CONTPWM > CONV_INTEGER(unsigned(DUTY)) THEN
		IF CONTPWM > (10000 * CONV_INTEGER(unsigned(DUTY)) + 1000) THEN
			LEDAUX <= '0';
		ELSE
			LEDAUX <= '1';
		END IF;
	END PROCESS;
	LED <= LEDAUX;
	OTHERLEDS <= "000000000";
END prac5;