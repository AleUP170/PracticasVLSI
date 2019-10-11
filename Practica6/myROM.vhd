LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL; -- Bibliotecas mínimas

ENTITY myROM IS
GENERIC(
	addr_width: integer := 16;
	addr_bits: integer := 4;
	data_width: integer := 7
);
PORT(
	addr: in std_logic_vector(addr_bits-1 downto 0);
	data: out std_logic_vector(data_width-1 downto 0)
);
END myROM;

ARCHITECTURE x OF myROM IS
	TYPE ROM IS ARRAY (0 TO addr_width-1) OF std_logic_vector(data_width-1 downto 0);
	SIGNAL DISP7SEG: ROM:= 	("1000001",  -- V
									 "1000111",  -- L
									 "0010010",  -- S
									 "1111001",  -- I
									 "0111111",  -- -
									 "0100100",  -- 2
									 "1000000",  -- 0
									 "0100100",  -- 2
									 "1000000",  -- 0
									 "0111111",  -- -
									 "1111001",  -- 1
									 "0111111",  -- -
									 "0001000",  -- A
									 "1000001",  -- U
									 "0001100",  -- P
									 "1111111");
BEGIN
	data <= DISP7SEG(CONV_INTEGER(unsigned(addr)));
END x;