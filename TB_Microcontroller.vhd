library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_Microcontroller is
END TB_Microcontroller;

ARCHITECTURE simulate OF TB_Microcontroller IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT Microcontroller
		PORT	
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
			WAET			: OUT STD_LOGIC
		 );
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '0';
	SIGNAL SIM_REG_CLOCK 	: STD_LOGIC := '0';
	SIGNAL SIM_IMC_CLOCK 	: STD_LOGIC := '0';
	SIGNAL SIM_IO	 			: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_RESET			: STD_LOGIC := '0';
	SIGNAL SIM_HOLD			: STD_LOGIC := '0';
	SIGNAL SIM_INT				: STD_LOGIC := '0';
	SIGNAL SIM_READY			: STD_LOGIC := '0';
	------------ OUTPUTS ------------
	SIGNAL SIM_INTE 			: STD_LOGIC;
	SIGNAL SIM_DBIN 			: STD_LOGIC;
	SIGNAL SIM_WR 				: STD_LOGIC;
	SIGNAL SIM_SYNC 			: STD_LOGIC;
	SIGNAL SIM_HLDA 			: STD_LOGIC;
	SIGNAL SIM_WAET 			: STD_LOGIC;
	------------ DEBUG ------------
	SIGNAL DBG_MEM_CLOCK		: STD_LOGIC;
	SIGNAL DBG_MEM_DATA		: UNSIGNED(15 downto 0);
	
	------------ CONSTANT ------------
	constant CLK_PERIOD : time := 5 ns;
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: Microcontroller 
	PORT MAP 
		( 
			CLOCK			=> SIM_CLOCK,
			REG_CLOCK	=> SIM_REG_CLOCK,
			IMC_CLOCK	=> SIM_IMC_CLOCK,
			IO				=> SIM_IO,
			RESET			=> SIM_RESET,
			HOLD			=> SIM_HOLD,
			INT			=> SIM_INT,
			INTE			=> SIM_INTE,
			DBIN			=> SIM_DBIN,
			WR				=> SIM_WR,
			SYNC			=> SIM_SYNC,
			HLDA			=> SIM_HLDA,
			READY			=> SIM_READY,
			WAET			=> SIM_WAET
		 );
		 
	------------ Start of Processes ------------	
	CPU_CLK_GEN: process
	variable delay : STD_LOGIC := '0';
	begin
		if (delay = '0') then
			delay := '1';
			wait for 25 ns;
		else
			SIM_CLOCK <= '0';
			wait for 25 ns;
			SIM_CLOCK <= '1';
			wait for 25 ns;
		end if;
	end process;
	
	REG_CLK_GEN: process
	begin
		SIM_REG_CLOCK <= '0';
		wait for 25 ns;
		SIM_REG_CLOCK <= '1';
		wait for 25 ns;
	end process;
	
	IMC_CLK_GEN: process
	variable continue : STD_LOGIC := '0';
	begin
		if (continue = '0') then
			INITIALIZE_MEMORY : for i in 0 to 255 loop
				SIM_IMC_CLOCK <= '0';
				wait for 1 ps;
				SIM_IMC_CLOCK <= '1';
				wait for 1 ps;
			end loop INITIALIZE_MEMORY;
			continue := '1';
		else
			wait for 10 ns; -- initialize memory
			SIM_IMC_CLOCK <= '0';
			--wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
			wait for 3.125 ns;
			SIM_IMC_CLOCK <= '1';
			--wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
			wait for 3.125 ns;
		end if;
	end process;
	
	SIM_IO <= "00000000"; --???
	
END simulate;