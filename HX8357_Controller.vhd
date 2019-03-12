library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.GaimBoiLibrary.ALL;

entity 	HX8357_Controller is
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
end HX8357_Controller;

architecture Structural of HX8357_Controller is

type RA is array (2 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
type RGB is array (2 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
type GRAM_ADDR is array (1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
type PARAM_TYPE is array (7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal PORT_ID		: STD_LOGIC_VECTOR(7 downto 0) := x"CD";
signal DEBUG		: STD_LOGIC_VECTOR(7 downto 0) := x"00";

begin

	process(CLOCK)
	variable COUNTER 		: INTEGER := 0;
	variable R_COUNT		: INTEGER := 0;
	variable W_COUNT		: INTEGER := 0;
	variable DATA			: STD_LOGIC_VECTOR(7 downto 0);
	variable INDEX			: INTEGER := 0;
	variable GET_COLUMN	: INTEGER := 0;
	variable GET_PAGE		: INTEGER := 0;
	variable GET_RGB		: INTEGER := 0;
	variable GET_DATA		: INTEGER := 0;
	variable GET_OSC		: INTEGER := 0;
	variable GRAM			: GRAM_ADDR;
	variable PIXEL			: RGB;
	variable DATA_IN		: STD_LOGIC_VECTOR(7 downto 0);
	variable W_MODE		: STD_LOGIC := '0';
	variable GET_IPF		: INTEGER := 0;
	variable GET_SPC		: STD_LOGIC := '0';
	variable RW_ENBL		: STD_LOGIC := '0';
	variable PARAMETERS	: PARAM_TYPE;
	begin
		if (rising_edge(CLOCK)) then
			LEDR <= ("00" & SW(7 downto 0));
			LCD_RST <= SW(8);
			if (RESET = '0') then
				COUNTER 	:= 0;
				R_COUNT 	:= 0;
				LCD_DCX 	<= '1';
				LCD_CS 	<= '1';
				LCD_DCX 	<= '1';
				LCD_WR 	<= '1';
				LCD_RD 	<= '1';
				LCD_DAT 	<= (others => 'Z');
				GET_COLUMN 	:= 0;
				GET_PAGE 	:= 0;
				MCU_INT 		<= '0';
				GET_RGB 		:= 0;
				GET_IPF		:= 0;
				W_MODE 		:= '0';
				GET_OSC 		:= 0;
				GET_DATA 	:= 0;
				GET_SPC 		:= '0';
				INDEX := 0;
				RW_ENBL := '0';
			else
				if ((COUNTER = 0) and (MCU_IORQ = '1')) then
					if (MCU_ADD(7 downto 0) = PORT_ID) then
						if (W_MODE = '0') then
							LCD_DCX <= '0'; -- falling edge of DCX
							LCD_RD <= '1'; -- hold RD high
							LCD_WR <= '0'; -- falling edge of write
						end if;
						LCD_DAT 	<= (others => '0');
						LCD_CS <= '0'; -- falling edge of chip select
						COUNTER := 1;
					end if;
				elsif ((COUNTER = 1) and (MCU_IORQ = '1') and (MCU_WR = '1')) then -- nop instruction
					if (W_MODE = '0') then
						LCD_WR <= '1'; -- rising edge of write
					end if;
					COUNTER := 2;
				elsif ((COUNTER = 2) and (MCU_IORQ = '1') and (MCU_WR = '1')) then
					if ((GET_DATA /= 0) and (RW_ENBL = '0')) then
						PARAMETERS(INDEX) := MCU_DAT;
						INDEX := (INDEX+1);
						DEBUG(0) <= NOT(DEBUG(0));
						if (INDEX = GET_DATA) then
							INDEX := 0; -- reset counter for writing
							RW_ENBL := '1'; -- enable writing
							COUNTER := 3;
							DEBUG(1) <= NOT(DEBUG(1));
							if (W_MODE = '0') then
								LCD_DAT <= DATA;
								LCD_WR <= '0';
								if (DATA = X"2C") then
									W_MODE := '1';
								end if;
							end if;
						end if;
					else
						DATA := MCU_DAT;
						if (DATA /= x"2C") then
							W_MODE := '0';
						end if;
						case DATA is
							when x"00" => -- NOP
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"00";
								R_COUNT := 0;
							when x"01" => -- SOFTWARE RESET
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"01";
								R_COUNT := 0;
							when x"09" => -- READ DISPLAY STATUS
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"09";
								R_COUNT := 10;
							when x"0A" => -- READ DISPLAY POWER MODE
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"0A";
								R_COUNT := 4;
							when x"0B" => -- READ DISPLAY MADCTL
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"0B";
								R_COUNT := 4;
							when x"0C" => -- READ DISPLAY PIXEL FORMAT
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"0C";
								R_COUNT := 4;
							when x"0D" => -- READ DISPLAY IMAGE MODE
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"0D";
								R_COUNT := 4;
							when x"0E" => -- READ DISPLAY SIGNAL MODE
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"0E";
								R_COUNT := 6;
							when x"10" => -- SLEEP IN
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"10";
								R_COUNT := 0;
							when x"11" => -- SLEEP OUT
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"11";
								R_COUNT := 0;
							when x"13" => -- NORMAL DISPLAY MODE ON
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"13";
								R_COUNT := 0;
							when x"20" => --  DISPLAY INVERSION OFF
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"20";
								R_COUNT := 0;
							when x"21" => --  DISPLAY INVERSION ON
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"21";
								R_COUNT := 0;
							when x"22" => -- ALL PIXELS OFF
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"22";
								R_COUNT := 0;
							when x"23" => -- ALL PIXELS ON 
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"23";
								R_COUNT := 0;
							when x"28" => -- DISPLAY OFF
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"28";
								R_COUNT := 0;
							when x"29" => -- DISPLAY ON
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"29";
							when x"2A" => -- COLUMN ADDRESS SET
								LCD_DAT <= X"00";
								GET_DATA := 4;
							when x"2B" => -- PAGE ADDRESS SET
								LCD_DAT <= X"00";
								GET_DATA := 4;
							when x"2C" => -- MEMORY WRITE
								LCD_DAT <= X"00";
								GET_DATA := 3;
							when x"2E" => -- MEMORY READ
								
							when x"36" => -- MEMORY ACCESS CONTROL
							
							when x"38" => -- IDLE MODE OFF
								LCD_DAT <= X"38";
							when x"3A" => -- INETRFACE PIXEL FORMAT
								GET_DATA := 1;
							when x"3C" => -- MEMORY WRITE CONTINUE
								
							when x"51" => -- WRITE DISPLAY BRIGHTNESS VALUE
							
							when x"54" => -- READ CTRL DISPLAY VALUE
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"54";
								R_COUNT := 4;
							when x"B0" => -- SET INTERNAL OSCILLATOR
								GET_DATA := 2;
							when x"B9" => -- TOGGLE EXTENDED COMMANDD
								GET_DATA := 3;
							when x"CC" => -- SET PANEL CHARACTERISTIC
								GET_DATA := 1;
							when x"DA" => -- READ  ID1
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"DA";
								R_COUNT := 4;
							when x"DB" => -- READ  ID2
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"DB";
								R_COUNT := 4;
							when x"DC" => -- READ  ID3
								LCD_DCX <= '0'; 
								LCD_RD <= '1';
								LCD_WR <= '0';
								LCD_CS <= '0';
								LCD_DAT <= X"DC";
								R_COUNT := 4;
							when others =>
								
						end case;
					end if;
					COUNTER := 3;
				elsif (COUNTER = 3) then -- clock instruction
					LCD_WR <= '1'; -- latch instruction
					COUNTER := 4;
				elsif (COUNTER = 4) then -- reset D/CX
					LCD_DCX <= '1';
					LCD_DAT <= (others => 'Z'); -- !!!
					COUNTER := 5;
				elsif (COUNTER = 5) then
					if ((GET_DATA > 0) and (RW_ENBL = '1')) then -- write parameters to HX8357
						if (LCD_WR = '1') then
							LCD_DAT <= PARAMETERS(INDEX);
						else
							INDEX := (INDEX+1);
							if (INDEX = GET_DATA) then
								RW_ENBL := '0';
								INDEX := 0;
								GET_DATA := 0;
							end if;
						end if;
						LCD_WR <= NOT(LCD_WR); -- clock data in
					elsif (R_COUNT > 0) then -- read data in from HX8357
						LCD_RD <= NOT(LCD_RD); -- clock data in
						R_COUNT := (R_COUNT-1);
					elsif (MCU_IORQ = '0') then -- continue
						LCD_DAT <= (others => 'Z');
						LCD_DCX <= '1';
						COUNTER := 0;
						if (W_MODE = '0') then
							LCD_CS <= '1'; -- disable chip
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end Structural; 