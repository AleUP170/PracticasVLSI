LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY myROM IS
GENERIC(
	addr_width: integer := 40;
	addr_bits: integer := 6;
	data_width: integer := 9
);
PORT(
	addr: in std_logic_vector(addr_bits-1 downto 0);
	data: out std_logic_vector(data_width-1 downto 0)
);
END myROM;

ARCHITECTURE x OF myROM IS
	TYPE ROM IS ARRAY (0 TO addr_width-1) OF std_logic_vector(data_width-1 downto 0);
	SIGNAL LEDS: ROM:=("001010110",
							 "001010110",
							 "011001110",
							 "011001110",
							 "001010110",
							 "001010110",
							 "011001110",
							 "011001110",
							 "010100100",
							 "010100100",
							 "010100100",
							 "010100100",
							 "010100100",
							 "010100100",
							 "010100100",
							 "010100100",
							 "001011001",
							 "100011000",
							 "001011001",
							 "100011000",
							 "001011001",
							 "100011000",
							 "001011001",
							 "100011000",
							 "010001000",
							 "010001000",
							 "010001000",
							 "010001000",
							 "100001000",
							 "100001000",
							 "100001000",
							 "100001000",
							 "000010100",
							 "000010100",
							 "000010100",
							 "000010100",
							 "000010100",
							 "000010100",
							 "000010100",
							 "000010100");
BEGIN
	data <= LEDS(CONV_INTEGER(unsigned(addr)));
END x;