library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Microcontroller is
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

end Microcontroller;

architecture Structural of Microcontroller is

	------------ Component Declarations ------------	
	COMPONENT CPU
		PORT
		(	
			CLOCK0		: IN STD_LOGIC;
			CLOCK1		: IN STD_LOGIC;
			ADDRESS		: OUT UNSIGNED(15 downto 0);
			DATA_IN		: IN UNSIGNED(7 downto 0);
			DATA_OUT		: OUT UNSIGNED(7 downto 0);
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
			IMC_CE		: OUT STD_LOGIC; -- IMC chip enable
			WAET			: OUT STD_LOGIC;
			PC				: OUT UNSIGNED(15 downto 0)
		 );
	END COMPONENT;
	
	COMPONENT IMC IS
		PORT
		(
			CLOCK		: IN STD_LOGIC;
			RAM_ADDR	: OUT STD_LOGIC_VECTOR (14 DOWNTO 0);
			RAM_CLK	: OUT STD_LOGIC  := '1';
			RAM_Q		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			RAM_DATA	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			RAM_WREN	: OUT STD_LOGIC := '1';
			R_ADDR0	: IN UNSIGNED(15 downto 0);
			R_DATA0	: OUT UNSIGNED(7 downto 0);
			R_ADDR1	: IN UNSIGNED(15 downto 0);
			R_DATA1	: OUT UNSIGNED(7 downto 0);
			W_ADDR	: IN UNSIGNED(15 downto 0);
			W_DATA	: IN UNSIGNED(7 downto 0);
			W_ENBL	: IN STD_LOGIC; 
			CE			: IN STD_LOGIC
		);
	END COMPONENT IMC;
	
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
	signal WIRE_IMC_ADDR : UNSIGNED(15 downto 0);
	signal WIRE_IMC_DATI : UNSIGNED(15 downto 0);
	signal WIRE_IMC_DATO : UNSIGNED(7 downto 0);
	signal WIRE_RAM_ADDR : STD_LOGIC_VECTOR(14 downto 0);
	signal WIRE_RAM_DATA : STD_LOGIC_VECTOR(7 downto 0);
	signal WIRE_RAM_Q 	: STD_LOGIC_VECTOR(7 downto 0);
	signal WIRE_IDK	 	: UNSIGNED(7 downto 0);
	signal WIRE_RAM_CLK 	: STD_LOGIC;
	signal WIRE_RAM_WREN : STD_LOGIC;
	signal WIRE_W_WREN 	: STD_LOGIC;
	signal WIRE_IMC_CE 	: STD_LOGIC;
	signal WIRE_PC			: UNSIGNED(15 downto 0);
------------ Start of Design ------------
begin

	------------ Component Instantiations ------------
	CPU0: CPU
	PORT MAP
		(
			CLOCK0		=> CLOCK,
			CLOCK1		=> REG_CLOCK,
			ADDRESS		=> WIRE_IMC_ADDR,
			DATA_IN		=> WIRE_IMC_DATI(15 downto 8),
			DATA_OUT		=> WIRE_IMC_DATO,
			IO				=> IO,
			RESET			=> RESET,
			HOLD			=> HOLD,
			INT			=> INT,
			INTE			=> INTE,
			DBIN			=> DBIN,
			WR				=>	WR,
			SYNC			=> SYNC,
			HLDA			=> HLDA,
			READY			=> READY,
			IMC_CE		=> WIRE_IMC_CE,
			WAET			=> WAET,
			PC				=> WIRE_PC
		 );
	
	MemoryController: IMC 
	PORT MAP 
		( 
			CLOCK			=> IMC_CLOCK,
			RAM_ADDR		=> WIRE_RAM_ADDR,
			RAM_CLK		=> WIRE_RAM_CLK,
			RAM_Q			=> WIRE_RAM_Q,
			RAM_DATA		=> WIRE_RAM_DATA,
			RAM_WREN		=> WIRE_RAM_WREN,
			R_ADDR0		=> WIRE_PC,
			R_DATA0		=> WIRE_IMC_DATI(15 downto 8),
			R_ADDR1		=> WIRE_PC,
			R_DATA1		=> WIRE_IMC_DATI(7 downto 0),
			W_ADDR		=> WIRE_PC,
			W_DATA		=> WIRE_IMC_DATO,
			W_ENBL		=> '1',
			CE				=> WIRE_IMC_CE
		 );
		 
		Memory: RAM
		PORT MAP
			(
				address	=> WIRE_RAM_ADDR,
				clock		=> WIRE_RAM_CLK,
				data		=> WIRE_RAM_DATA,
				wren		=> WIRE_RAM_WREN,
				q			=> WIRE_RAM_Q
			);
		 
end Structural; 