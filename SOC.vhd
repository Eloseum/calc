library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity SOC is
    Port 
	 ( 
		CLOCK			: IN STD_LOGIC; -- 8.4Mhz
		REG_CLOCK	: IN STD_LOGIC;
		IMC_CLOCK	: IN STD_LOGIC; -- 50.4Mhz
		IO				: INOUT STD_LOGIC_VECTOR(7 downto 0);
		RESET			: IN STD_LOGIC;
		HOLD			: IN STD_LOGIC;
		INT			: IN STD_LOGIC;
		INTE			: OUT STD_LOGIC;
		DBIN			: OUT STD_LOGIC;
		WR				: OUT STD_LOGIC;
		SYNC			: OUT STD_LOGIC;
		HLDA			: OUT STD_LOGIC;
		READY			: IN STD_LOGIC;
		WAET			: OUT STD_LOGIC;
		PC				: OUT UNSIGNED(15 downto 0)
	 );

end SOC;

architecture Structural of SOC is

	------------ Component Declarations ------------	
	COMPONENT Processor
    Port 
	 ( 
		ADDRESS	: OUT UNSIGNED(15 downto 0);
		DATA		: INOUT STD_LOGIC_VECTOR(7 downto 0);
		CLOCK		: IN STD_LOGIC;
		INT		: IN STD_LOGIC;
		NMI		: IN STD_LOGIC;
		HALT		: OUT STD_LOGIC;
		MREQ		: OUT STD_LOGIC;
		IORQ		: OUT STD_LOGIC;
		RD			: OUT STD_LOGIC;
		WR			: OUT STD_LOGIC;
		BUSAK		: OUT STD_LOGIC;
		WAET		: IN STD_LOGIC;
		BUSRQ		: IN STD_LOGIC;
		RESET		: IN STD_LOGIC;
		MI			: OUT STD_LOGIC;
		RFSH		: OUT STD_LOGIC
	 );
	END COMPONENT;
	
	COMPONENT RAM IS
		PORT
		(
			address	: IN STD_LOGIC_VECTOR(14 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			wren		: IN STD_LOGIC;
			q			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT RAM;

	------------ Signal Declarations ------------
	signal WIRE_ADDR : UNSIGNED(15 downto 0);
	
	------------ Start of Design ------------
begin

	------------ Component Instantiations ------------
	IC_0: Processor
	PORT MAP
		(
			ADDRESS	=> WIRE_ADDR,
			DATA		=> 
			CLOCK		=> 
			INT		=> 
			NMI		=> 
			HALT		=> 
			MREQ		=> 
			IORQ		=> 
			RD			=> 
			WR			=> 
			BUSAK		=> 
			WAET		=> 
			BUSRQ		=> 
			RESET		=> 
			MI			=> 
			RFSH		=> 
		 );
		 
		IC_1: RAM
		PORT MAP
			(
				address	=> WIRE_ADDR,
				clock		=> WIRE_RAM_CLK,
				data		=> WIRE_RAM_DATA,
				wren		=> WIRE_RAM_WREN,
				q			=> WIRE_RAM_Q
			);
		 
end Structural; 