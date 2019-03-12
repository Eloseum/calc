library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_TOP is
END TB_TOP;

ARCHITECTURE simulate OF TB_TOP IS

	COMPONENT TOP
		PORT	
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
			GPIO_0		: INOUT STD_LOGIC_VECTOR(35 downto 0);
			GPIO_1		: IN STD_LOGIC_VECTOR(35 downto 0)
		 );
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '1';
	SIGNAL SIM_DATA	 		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_ADDR	 		: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	SIGNAL SIM_HALT			: STD_LOGIC := '1';
	SIGNAL SIM_MREQ			: STD_LOGIC := '0';
	SIGNAL SIM_IORQ			: STD_LOGIC := '0';
	SIGNAL SIM_RD				: STD_LOGIC := '0';
	SIGNAL SIM_RESET			: STD_LOGIC := '0';
	------------ OUTPUTS ------------
	SIGNAL SIM_BUSAK 			: STD_LOGIC;
	SIGNAL SIM_DBIN 			: STD_LOGIC;
	SIGNAL SIM_WR 				: STD_LOGIC;
	SIGNAL SIM_SYNC 			: STD_LOGIC;
	SIGNAL SIM_RFSH 			: STD_LOGIC;
	SIGNAL SIM_MI 			: STD_LOGIC;
	------------ DEBUG ------------
	SIGNAL DBG_MEM_CLOCK		: STD_LOGIC;
	SIGNAL DBG_MEM_DATA		: UNSIGNED(15 downto 0);
	SIGNAL WIRE_GPIO_0		: STD_LOGIC_VECTOR(35 downto 0);
	SIGNAL WIRE_GPIO_1		: STD_LOGIC_VECTOR(35 downto 0);
	SIGNAL SIM_HEX0			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_HEX1			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_HEX2			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_HEX3			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_HEX4			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_HEX5			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL SIM_SW				: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
	SIGNAL SIM_KEY				: STD_LOGIC_VECTOR(3 downto 0) := (others => '1');
	
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: TOP 
	PORT MAP 
		( 
			CLOCK_50		=> SIM_CLOCK,
			CLOCK2_50	=> SIM_CLOCK,
			CLOCK3_50	=> SIM_CLOCK,
			CLOCK4_50	=> SIM_CLOCK,
			SW				=> SIM_SW,
			KEY			=> SIM_KEY,
			HEX0			=> SIM_HEX0,
			HEX1			=> SIM_HEX1,
			HEX2			=> SIM_HEX2,
			HEX3			=> SIM_HEX3,
			HEX4			=> SIM_HEX4,
			HEX5			=> SIM_HEX5,
			GPIO_0		=> WIRE_GPIO_0,
			GPIO_1		=> WIRE_GPIO_1
		 );
		 
	------------ Start of Processes ------------	
	CPU_CLK_GEN: process
	variable counter : INTEGER := 0;
	begin
		SIM_CLOCK <= '0';
		wait for 500 ns;
		SIM_CLOCK <= '1';
		if (counter < 1) then
			SIM_RESET <= '0';
			counter := (counter+1);
		else
			SIM_RESET <= '1';
		end if;
		wait for 500 ns;
	end process;
	
	SIM_SW(9) 			<= SIM_RESET;
	WIRE_GPIO_1(0) 	<= SIM_CLOCK;
	
END simulate;