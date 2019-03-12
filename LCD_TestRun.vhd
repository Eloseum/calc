library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.GaimBoiLibrary.ALL;

entity 	LCD_TestRun is
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
		GPIO_1		: IN STD_LOGIC_VECTOR(35 downto 0)
	 );
end LCD_TestRun;

architecture Structural of LCD_TestRun is

	--- COMPONENT DECLARATIONS ---
	COMPONENT 	LCD_Interface is
		 Port 
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
	END COMPONENT LCD_Interface;
	
	SIGNAL TEST_RESET : STD_LOGIC;
	SIGNAL TEST_INT	: STD_LOGIC;
	SIGNAL TEST_BUSRQ	: STD_LOGIC;

begin

	------------ Component Instantiations ------------

	uut : LCD_Interface
	PORT MAP 
	(
		CLOCK			=> GPIO_1(0),
		RESET			=> SW(9),
		MCU_IORQ		=> '0',
		MCU_WR		=> '0',
		MCU_RD		=> '0',
		MCU_DAT		=> x"00",
		MCU_ADD		=> X"00",
		MCU_INT		=> TEST_INT,
		MCU_BUSRQ	=> TEST_BUSRQ,
		LCD_RST		=> GPIO_0(0),
		LCD_CS		=> GPIO_0(1),
		LCD_DCX		=> GPIO_0(2),
		LCD_WR		=> GPIO_0(3),
		LCD_RD		=> GPIO_0(4),
		LCD_DAT		=> GPIO_0(12 downto 5),
		LEDR			=> LEDR,
		SW				=> SW(8 downto 0)
	);
--	
--	process(CLOCK_0)
--	variable COUNTER 		: INTEGER := 0;
--	variable R_COUNT		: INTEGER := 0;
--	variable W_COUNT		: INTEGER := 0;
--	variable DATA			: STD_LOGIC_VECTOR(7 downto 0);
--	variable RGB			: RA;
--	variable TEST 			: STD_LOGIC := '1';
--	variable INDEX			: INTEGER := 0;
--	variable PARAMETERS	: PARAM_TYPE := 
--	(
--		x"07",
--		x"06",
--		x"05",
--		x"04",
--		x"03",
--		x"02",
--		x"01",
--		x"00"
--	);
--	variable DATA_IN	: STD_LOGIC_VECTOR(7 downto 0);
--	begin
--		if (rising_edge(CLOCK_0)) then
--			LEDR(7 downto 0) <= SW;
--			if (RESET = '0') then
--				COUNTER 	:= 0;
--				R_COUNT 	:= 0;
--				LCD_DCX 	<= '1';
--				LCD_CS 	<= '1';
--				LCD_DCX 	<= '1';
--				LCD_WR 	<= '1';
--				LCD_RD 	<= '1';
--				LCD_DAT 	<= (others => 'Z');
--				TEST := '1';
--			else
--				if ((COUNTER = 0) and (MCU_IORQ = '1')) or ((TEST = '1') and (COUNTER = 0)) then
--					if (MCU_ADD(7 downto 0) = PORT_ID) or (TEST = '1') then
--						LCD_DCX <= '0'; -- falling edge of DCX
--						LCD_RD <= '1'; -- hold RD high
--						LCD_WR <= '0'; -- falling edge of write
--						LCD_DAT 	<= (others => '0');
--						LCD_CS <= '0'; -- falling edge of chip select
--						COUNTER := 1;
--					end if;
--				elsif ((COUNTER = 1) and (MCU_IORQ = '1') and (MCU_WR = '1')) or ((TEST = '1') and (COUNTER = 1)) then -- nop instruction
--					LCD_WR <= '1'; -- rising edge of write
--					COUNTER := 2;
--				elsif ((COUNTER = 2) and (MCU_IORQ = '1') and (MCU_WR = '1')) or ((TEST = '1') and (COUNTER = 2)) then
--					DATA := SW(7 downto 0);
--					case DATA is
--						when x"01" => -- SOFTWARE RESET
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"01";
--							R_COUNT := 0;
--						when x"09" => -- READ DISPLAY STATUS
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"09";
--							R_COUNT := 10;
--						when x"0A" => -- READ DISPLAY POWER MODE
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"0A";
--							R_COUNT := 4;
--						when x"0B" => -- READ DISPLAY MADCTL
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"0B";
--							R_COUNT := 4;
--						when x"0C" => -- READ DISPLAY PIXEL FORMAT
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"0C";
--							R_COUNT := 4;
--						when x"0D" => -- READ DISPLAY IMAGE MODE
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"0D";
--							R_COUNT := 4;
--						when x"0E" => -- READ DISPLAY SIGNAL MODE
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"0E";
--							R_COUNT := 6;
--						when x"10" => -- SLEEP IN
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"10";
--							R_COUNT := 0;
--						when x"11" => -- SLEEP OUT
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"11";
--							R_COUNT := 0;
--						when x"13" => -- NORMAL DISPLAY MODE ON
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"13";
--							R_COUNT := 0;
--						when x"20" => --  DISPLAY INVERSION ON
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"20";
--							R_COUNT := 0;
--						when x"21" => --  DISPLAY INVERSION ON
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"21";
--							R_COUNT := 0;
--						when x"22" => -- ALL PIXELS OFF
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"22";
--							R_COUNT := 0;
--						when x"23" => -- ALL PIXELS ON 
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"23";
--							R_COUNT := 0;
--						when x"28" => -- DISPLAY OFF
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"28";
--							R_COUNT := 0;
--						when x"29" => -- DISPLAY ON
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"29";
--							R_COUNT := 0;
--						when x"2A" => -- COLUMN ADDRESS SET
--							
--						when x"2B" => -- PAGE ADDRESS SET
--							
--						when x"2C" => -- MEMORY WRITE
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"2C";
--							W_COUNT := 30000;
--							INDEX := 5;
--						when x"2E" => -- MEMORY READ
--							
--						when x"36" => -- MEMORY ACCESS CONTROL
--							
--						when x"3A" => -- INETRFACE PIXEL FORMAT
--							
--						when x"3C" => -- MEMORY WRITE CONTINUE
--							
--						when x"51" => -- WRITE DISPLAY BRIGHTNESS VALUE
--						
--						when x"54" => -- READ CTRL DISPLAY VALUE
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"54";
--							R_COUNT := 4;
--						when x"B0" => -- INTERFACE MODE CONTROL
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"B0";
--							W_COUNT := 4;
--							INDEX := 0;
--						when x"DA" => -- READ  ID1
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"DA";
--							R_COUNT := 4;
--						when x"DB" => -- READ  ID2
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"DB";
--							R_COUNT := 4;
--						when x"DC" => -- READ  ID3
--							LCD_DCX <= '0'; 
--							LCD_RD <= '1';
--							LCD_WR <= '0';
--							LCD_CS <= '0';
--							LCD_DAT <= X"DC";
--							R_COUNT := 4;
--						when others =>
--							
--					end case;
--					COUNTER := 3;
--				elsif (COUNTER = 3) then -- clock instruction
--					LCD_WR <= '1'; -- latch instruction
--					COUNTER := 4;
--				elsif (COUNTER = 4) then -- reset D/CX
--					LCD_DCX <= '1';
--					LCD_DAT <= (others => 'H'); -- !!!
--					COUNTER := 5;
--				elsif (COUNTER = 5) then
--					if (R_COUNT > 0) then -- read data in from ILI9488
--						LCD_RD <= NOT(LCD_RD); -- clock data in
--						R_COUNT := (R_COUNT-1);
--					elsif (W_COUNT > 0) then -- write parameters to ILI9488
--						if (LCD_WR = '1') then
--							if (INDEX /= 0) then
--								LCD_DAT <= PARAMETERS(INDEX);
--								INDEX := (INDEX+1);
--							else
--								LCD_DAT <= x"00";
--							end if;
--						end if;
--						LCD_WR <= NOT(LCD_WR); -- clock data in
--						W_COUNT := (W_COUNT-1);
--					elsif ((MCU_IORQ = '0') or (TEST = '1')) then -- continue
--						LCD_DAT <= (others => 'Z');
--						LCD_DCX <= '1';
--						LCD_CS <= '1'; -- disable chip
--						COUNTER := 0;
--						INDEX := 0;
--						TEST := '0';
--					end if;
--				end if;
--			end if;
--		end if;
--	end process;
	         
--	-- 	CONTROL 	--
--	GPIO_0(0) <= LCD_RST;
--	GPIO_0(1) <= LCD_CS;
--	GPIO_0(2) <= LCD_DCX;
--	GPIO_0(3) <= LCD_WR;
--	GPIO_0(4) <= LCD_RD;
--	-- 	DATA 		--
--	GPIO_0(5) 	<= LCD_DAT(7);
--	GPIO_0(6) 	<= LCD_DAT(6);
--	GPIO_0(7) 	<= LCD_DAT(5);
--	GPIO_0(8) 	<= LCD_DAT(4);
--	GPIO_0(9) 	<= LCD_DAT(3);
--	GPIO_0(10) 	<= LCD_DAT(2);
--	GPIO_0(11) 	<= LCD_DAT(1);
--	GPIO_0(12) 	<= LCD_DAT(0);
--	GPIO_0(13) 	<= CLOCK;
	-- 	DEBUG 		--
--	GPIO_0(5) 	<= LCD_DAT(7);
--	GPIO_0(6) 	<= LCD_DAT(6);
--	GPIO_0(7) 	<= LCD_DAT(5);
--	GPIO_0(8) 	<= LCD_DAT(4);
--	GPIO_0(9) 	<= LCD_DAT(3);
--	GPIO_0(10) 	<= LCD_DAT(2);
--	GPIO_0(11) 	<= LCD_DAT(1);
--	GPIO_0(12) 	<= LCD_DAT(0);
--	GPIO_0(13) 	<= CLOCK;

	--RESET <= SW(9);
	--LCD_RST 	<= SW(8);
	
end Structural; 