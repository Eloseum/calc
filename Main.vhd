library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Main is
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

end Main;

architecture Behavioral of Main is

	------------ Component Declarations ------------
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
	Memory: RAM
	PORT MAP
		(
			address	=> WIRE_RAM_ADDR,
			clock		=> WIRE_RAM_CLK,
			data		=> WIRE_RAM_DATA,
			wren		=> WIRE_RAM_WREN,
			q			=> WIRE_RAM_Q
		);
		
		------------ Processes ------------
		FETCH: process(CLOCK)
		-- needs to get instruction from integrated memory controller
		begin
			if rising_Edge(CLOCK) then
				
			end if;
		end process;
		
		IMC: process(CLOCK)
		begin
		if (rising_edge(CLOCK) and ((CE = '0') or (DBG_INIT_MEM = '1'))) then
			if (DBG_INIT_MEM = '1') then -- !!!initialize memory, only for simulation!!!
				if (counter < 256) then
					if (counter mod 2 = 0) then
							RAM_ADDR <= STD_LOGIC_VECTOR(DBG_INIT_ADD); -- update address
							RAM_DATA <= STD_LOGIC_VECTOR(DBG_INIT_ADD(7 downto 0)); -- data to write
							RAM_WREN	<= '1'; -- enable writing
							RAM_CLK <= '0'; -- falling edge of clock
							counter := (counter+1);
						else
							RAM_CLK <= '1'; -- rising edge of clock, should update data
							counter := (counter+1);
							DBG_INIT_ADD := (UNSIGNED(DBG_INIT_ADD)+1);
						end if;
				else
					counter := 0;
					RAM_WREN <= '0'; -- disable writing
					DBG_INIT_MEM := '0'; -- memory has been initialized, continue
				end if;
			else
				------------ Fetch Instruction Cycle ------------
				if (counter = 0) then
					--RAM_ADDR <= ADDRESS(30 downto 16); -- update address
					RAM_ADDR <= STD_LOGIC_VECTOR(R_ADDR0(14 downto 0));
					RAM_CLK <= '0'; -- falling edge of clock
					RAM_WREN	<= '1'; -- disable writing
					counter := 1;
				elsif (counter = 1) then
					RAM_CLK <= '1'; -- rising edge of clock
					counter := 2;
				elsif (counter = 2) then
					R_DATA0 <= UNSIGNED(RAM_Q); -- instruction fetch
					counter := 3;
				------------ Fetch Immediate Cycle ------------
				elsif (counter = 3) then
					--RAM_ADDR <= IMM_ADDR(14 downto 0); -- update address
					RAM_ADDR <= STD_LOGIC_VECTOR(R_ADDR1(14 downto 0));
					RAM_CLK <= '0'; -- falling edge of clock
					RAM_WREN	<= '1'; -- disable writing
					counter := 4;
				elsif (counter = 4) then
					RAM_CLK <= '1'; -- rising edge of clock
					counter := 5;
				elsif (counter = 5) then
					R_DATA1 <= UNSIGNED(RAM_Q); -- immediate fetch
					counter := 6;
				else
				------------ Write Cycle ------------
					if (W_ENBL = '1') then
						if (counter = 6) then
							--RAM_ADDR <= ADDRESS(14 downto 0); -- update address
							RAM_ADDR <= STD_LOGIC_VECTOR(W_ADDR(14 downto 0)); -- test
							RAM_DATA <= STD_LOGIC_VECTOR(W_DATA); -- data to write
							RAM_WREN	<= '0'; -- enable writing
							RAM_CLK <= '0'; -- falling edge of clock
							counter := 7;
						elsif (counter = 7) then
							RAM_CLK <= '1'; -- rising edge of clock, should update data
							counter := 0; -- reset FetchWrite cycle
						end if;
					else
						if (counter = 6) then
							counter := 7;
						else
							counter := 0;
						end if;
					end if;
				end if;
			end if;
		end if;
		end process;
		
		
end Behavioral; 