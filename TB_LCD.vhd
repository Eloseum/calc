library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_LCD is
END TB_LCD;

ARCHITECTURE simulate OF TB_LCD IS

	COMPONENT LCD_Interface
		PORT	
		 ( 
			CLOCK			: IN STD_LOGIC;
			RESET			: IN STD_LOGIC;
			MCU_IORQ		: IN STD_LOGIC;
			MCU_WR		: IN STD_LOGIC;
			MCU_RD		: IN STD_LOGIC;
			MCU_DAT		: IN STD_LOGIC_VECTOR(7 downto 0);
			MCU_ADD		: IN STD_LOGIC_VECTOR(7 downto 0);
			MCU_INT		: OUT STD_LOGIC;
			MCU_BUSRQ	: OUT STD_LOGIC;
			LCD_RST		: OUT STD_LOGIC;
			LCD_CS		: OUT STD_LOGIC;
			LCD_DCX		: OUT STD_LOGIC;
			LCD_WR		: BUFFER STD_LOGIC;
			LCD_RD		: BUFFER STD_LOGIC;
			LCD_DAT		: INOUT STD_LOGIC_VECTOR(7 downto 0);
			LEDR			: OUT STD_LOGIC_VECTOR(9 downto 0);
			SW				: IN STD_LOGIC_VECTOR(8 downto 0)
		 );
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '0';
	SIGNAL SIM_MCU_IORQ		: STD_LOGIC := '0';
	SIGNAL SIM_MCU_WR			: STD_LOGIC := '0';
	SIGNAL SIM_MCU_RD			: STD_LOGIC := '0';
	SIGNAL SIM_MCU_DAT		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_MCU_ADD		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_MCU_INT		: STD_LOGIC := '0';
	SIGNAL SIM_MCU_BUSRQ		: STD_LOGIC := '0';
	SIGNAL SIM_RESET			: STD_LOGIC := '0';
	SIGNAL SIM_SW				: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
	------------ OUTPUTS ------------
	SIGNAL LCD_RST		: STD_LOGIC := '1';
	SIGNAL LCD_CS		: STD_LOGIC := '1';
	SIGNAL LCD_DCX		: STD_LOGIC := '1';
	SIGNAL LCD_WR		: STD_LOGIC := '1';
	SIGNAL LCD_RD		: STD_LOGIC := '1';
	SIGNAL LCD_DAT		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_LEDR	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: LCD_Interface 
	PORT MAP 
		( 
			CLOCK			=> SIM_CLOCK,
			RESET			=> SIM_RESET,
			MCU_IORQ		=> SIM_MCU_IORQ,
			MCU_WR		=> SIM_MCU_WR,
			MCU_RD		=> SIM_MCU_RD,
			MCU_DAT		=> SIM_MCU_DAT,
			MCU_ADD		=> SIM_MCU_ADD,
			MCU_INT		=> SIM_MCU_INT,
			MCU_BUSRQ	=> SIM_MCU_BUSRQ,
			LCD_RST		=> LCD_RST,
			LCD_CS		=> LCD_CS,
			LCD_DCX		=> LCD_DCX,
			LCD_WR		=> LCD_WR,
			LCD_RD		=> LCD_RD,
			LCD_DAT		=> LCD_DAT,
			LEDR			=> SIM_LEDR,
			SW				=> SIM_SW
		 );
		 
	------------ Start of Processes ------------	
	CPU_CLK_GEN: process
	variable counter : INTEGER := 0;
	begin
		SIM_CLOCK <= '0';
		wait for 50 ns;
		SIM_CLOCK <= '1';
		wait for 50 ns;
	end process;
	
	Reset: process
	begin
		SIM_RESET <= '0';
		wait for 100 ns;
		SIM_RESET <= '1';
		wait;
	end process;
	
	Stimulus: process
	begin
		wait for 100 ns;
		SIM_MCU_ADD <= x"CD";
		wait for 100 ns;
		SIM_MCU_DAT <= x"2A";
		wait for 100 ns;
		SIM_MCU_IORQ <= '1';
		wait for 100 ns;
		SIM_MCU_WR <= '1';
		wait;
	end process;
	
END simulate;