library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.GaimBoiLibrary.ALL;

entity Interface_Controller is
    Port 
	 ( 
		CLOCK		: IN STD_LOGIC;
		KEY		: IN STD_LOGIC_VECTOR(3 downto 0);
		SW			: IN STD_LOGIC_VECTOR(9 downto 0);
		INT		: BUFFER STD_LOGIC;
		IORQ		: IN STD_LOGIC;
		RD			: IN STD_LOGIC;
		ADDRESS	: IN STD_LOGIC_VECTOR(15 downto 0);
		RESET		: IN STD_LOGIC;
		LEDR		: BUFFER STD_LOGIC_VECTOR(9 downto 0);
		DATA		: INOUT STD_LOGIC_VECTOR(7 downto 0)
	 );
end Interface_Controller;

architecture Structural of Interface_Controller is
	
	------------ Type Declarations ------------
	type RA is array (7 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	------------ Signal Declarations ------------
	signal PORT_ID		: STD_LOGIC_VECTOR(7 downto 0) := x"AB";
	------------ Start of Design ------------
begin

	------------ Component Instantiations ------------

	CPU_INTERFACE: process(CLOCK)
	variable COUNTER 	: INTEGER := 0;
	variable CYCLE		: INTEGER := 0;
	variable FILTER 	: INTEGER := 0;
	variable TEMP 		: STD_LOGIC_VECTOR(7 downto 0);
	variable MEM		: STD_LOGIC := '0';
	begin
		if (rising_edge(CLOCK)) then
			if (RESET = '0') then
				INT <= '1';
				COUNTER := 0;
				FILTER := 0;
				MEM := '0';
				DATA <= (others => 'Z');
			elsif ((COUNTER = 0) and (KEY /= x"F") and (MEM = '0')) then
				if (CYCLE = 1) then
					TEMP := (SW(3 downto 0)&NOT(KEY));
					FILTER := 0;
				elsif (CYCLE < 3125000) and ((SW(3 downto 0)&NOT(KEY)) = TEMP) then
					FILTER := (FILTER+1);
				elsif ((CYCLE = 3125000) and (FILTER > 1562500)) then -- button pressed
					CYCLE := 0;
					FILTER := 0;
					COUNTER := 1;
					LEDR(7 downto 0) <= TEMP;
					MEM := '1';
					INT <= '0';
				elsif (CYCLE = 3125000) then -- ignore
					CYCLE := 0;
					FILTER := 0;
				end if;
				CYCLE := (CYCLE+1);

----				!!! SIMULATION !!!
--				INT <= '0';
--				TEMP := (SW(3 downto 0)&NOT(KEY));
--				LEDR(7 downto 0) <= TEMP;
--				COUNTER := 1;
--				MEM := '1';
----				!!! END OF SIMULATION !!!

				DATA <= (others => 'Z');
			elsif ((COUNTER = 0) and (MEM = '1')) then
				if (CYCLE = 1) then
					FILTER := 0;
				elsif (CYCLE < 3125000) and (KEY = x"F") then
					FILTER := (FILTER+1);
				elsif ((CYCLE = 3125000) and (FILTER > 1562500)) then -- button pressed
					CYCLE := 0;
					FILTER := 0;
					MEM := '0';
				elsif (CYCLE = 3125000) then -- ignore
					CYCLE := 0;
					FILTER := 0;
				end if;
				CYCLE := (CYCLE+1);
			elsif ((COUNTER = 1) and (IORQ = '1')) then -- compare io port address with device ID
				if (ADDRESS(7 downto 0) = PORT_ID) then
					INT <= '1';
					COUNTER := 2;
				end if;
			elsif ((COUNTER = 2) and (IORQ = '1') and (RD = '1')) then -- write data to processor
				DATA <= TEMP;
				COUNTER := 3;
			elsif (COUNTER = 3) then
				DATA <= (others => 'Z');
				COUNTER := 0;
			end if;
		end if;
	end process;
	
end Structural; 