LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY myROM IS
GENERIC(
	addr_width: integer := 9;
	addr_bits: integer := 4;
	data_width: integer := 17
);
PORT(
	addr: in std_logic_vector(addr_bits-1 downto 0);
	data: out std_logic_vector(data_width-1 downto 0)
);
END myROM;

ARCHITECTURE x OF myROM IS
	TYPE ROM IS ARRAY (0 TO addr_width-1) OF std_logic_vector(data_width-1 downto 0);
	SIGNAL LEDS: ROM:=("10000010100000000",
							 "00000100010010110",
							 "00001110111100100",
							 "00000100010011001",
							 "00001010101001110",
							 "01001110110001000",
							 "00000000000010100",
							 "00100111000000000",
							 "00001100110011000");
BEGIN
	data <= LEDS(CONV_INTEGER(unsigned(addr)));
END x;