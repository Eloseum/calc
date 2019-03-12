library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity LCD_TOP is
    Port 
	 ( 
		CLOCK_50		: IN STD_LOGIC;
		CLOCK2_50	: IN STD_LOGIC;
		CLOCK3_50	: IN STD_LOGIC;
		CLOCK4_50	: IN STD_LOGIC;
		SW				: IN STD_LOGIC_VECTOR(9 downto 0);
		KEY			: IN STD_LOGIC_VECTOR(3 downto 0);
		HEX0			: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX1			: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX2			: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX3			: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX4			: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX5			: OUT STD_LOGIC_VECTOR(6 downto 0);
		LEDR			: OUT STD_LOGIC_VECTOR(9 downto 0);
		GPIO_0		: INOUT STD_LOGIC_VECTOR(35 downto 0);
		GPIO_1		: INOUT STD_LOGIC_VECTOR(35 downto 0)
	 );
end LCD_TOP;

architecture Structural of LCD_TOP is

	COMPONENT 	LCD_TestRun is
    Port 
	 ( 
		
	 );
	END COMPONENT LCD_TestRun;
	
	COMPONENT TestClock is
	port 
	(
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_1 : out std_logic         -- outclk0.clk
	);
	END COMPONENT TestClock;
	
begin
	
	IC_0: LCD_TestRun
	PORT MAP
	(
		
	);
		
	IC_1: TestClock
	PORT MAP
	(
		refclk   	=> ,
		rst      	=> ,
		outclk_1 	=> 
	);
	
END Structural; 
