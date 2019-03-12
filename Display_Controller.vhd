library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.GaimBoiLibrary.ALL;

entity Display_Controller is
    Port 
	 ( 
		RESET 	: IN STD_LOGIC;
		IORQ		: IN STD_LOGIC;
		WR			: IN STD_LOGIC;
		ADDRESS	: IN STD_LOGIC_VECTOR(15 downto 0);
		DATA		: IN STD_LOGIC_VECTOR(7 downto 0);
		HEX0		: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX1		: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX2		: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX3		: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX4		: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX5		: OUT STD_LOGIC_VECTOR(6 downto 0)
	 );
end Display_Controller;

architecture Structural of Display_Controller is
	
	------------ Type Declarations ------------
	type RA is array (5 downto 0) of STD_LOGIC_VECTOR(6 downto 0);
	type LUT is array (0 to 10) of STD_LOGIC_VECTOR(6 downto 0);
	------------ Signal Declarations ------------
	signal DISPLAY_ROM : LUT := 
	(
		
		"1000000", --x"40", -- 0
		"1111001", --x"79", -- 1
		"0100100", --x"24", -- 2
		"0110000", --x"30", -- 3
		"0011001", --x"19", -- 4
		"0010010", --x"32", -- 5
		"0000010", --x"02", -- 6
		"1111000", --x"78", -- 7
		"0000000", --x"00", -- 8
		"0011000", --x"38", -- 9
		"1111111"  --x"FF"  -- .
	);
	signal PORT_ID		 : STD_LOGIC_VECTOR(7 downto 0) := x"AC";
	signal DISPLAY		 : RA :=
	(
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"0000000",
		"0000000"
	);
	------------ Start of Design ------------
begin

	process(IORQ, WR, RESET)
	variable COUNTER 	: INTEGER := 0;
	variable TEMP 		: STD_LOGIC_VECTOR(3 downto 0);
	begin
		if (RESET = '0') then
			COUNTER := 0;
			DISPLAY(0) <= DISPLAY_ROM(0);
			DISPLAY(1) <= DISPLAY_ROM(0);
			DISPLAY(2) <= DISPLAY_ROM(0);
			DISPLAY(3) <= DISPLAY_ROM(0);
			DISPLAY(4) <= DISPLAY_ROM(0);
			DISPLAY(5) <= DISPLAY_ROM(0);
		elsif ((COUNTER = 0) and (IORQ = '1')) then 
			if (ADDRESS(7 downto 0) = PORT_ID) then
				COUNTER := 1;
			end if;
		elsif ((COUNTER = 1) and (IORQ = '1') and (WR = '1')) then
			DISPLAY(TO_INTEGER(UNSIGNED(DATA(6 downto 4)))) <= DISPLAY_ROM(TO_INTEGER(UNSIGNED(DATA(3 downto 0))));
			COUNTER := 0;
		end if;
	end process;
	
	HEX0 <= DISPLAY(0);
	HEX1 <= DISPLAY(1);
	HEX2 <= DISPLAY(2);
	HEX3 <= DISPLAY(3);
	HEX4 <= DISPLAY(4);
	HEX5 <= DISPLAY(5);
	
end Structural; 