library IEEE;
use IEEE.std_logic_1164.ALL;


ENTITY TB_IMC is
END TB_IMC;

ARCHITECTURE simulate OF TB_IMC IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT IMC
		PORT	
			(
			------------ Clock ------------
			CLOCK		: IN STD_LOGIC; -- 6 clocks within a 8.4mhz cycle
			------------ RAM ------------
			RAM_Q		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			RAM_ADDR	: OUT STD_LOGIC_VECTOR (14 DOWNTO 0);
			RAM_CLK	: OUT STD_LOGIC;
			RAM_DATA	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			RAM_WREN	: OUT STD_LOGIC;
			------------ Fetch ------------
			F_ADDR	: IN STD_LOGIC_VECTOR(14 downto 0); -- address to read from
			F_DATA	: OUT STD_LOGIC_VECTOR(7 downto 0); -- data from RAM
			------------ Write ------------
			W_ADDR	: IN STD_LOGIC_VECTOR(14 downto 0); -- address to write to
			W_DATA	: IN STD_LOGIC_VECTOR(7 downto 0); -- data to write to RAM
			W_ENBL	: IN STD_LOGIC -- write enable
			);
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 		: STD_LOGIC := '0';
	SIGNAL SIM_RAM_Q 		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_F_ADDR 	: STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
	SIGNAL SIM_W_ADDR 	: STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
	SIGNAL SIM_W_DATA 	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	SIGNAL SIM_W_ENBL 	: STD_LOGIC := '0';
	------------ OUTPUTS ------------
	SIGNAL SIM_RAM_ADDR 	: STD_LOGIC_VECTOR(14 downto 0);
	SIGNAL SIM_RAM_CLK 	: STD_LOGIC;
	SIGNAL SIM_RAM_DATA 	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL SIM_RAM_WREN 	: STD_LOGIC;
	SIGNAL SIM_F_DATA 	: STD_LOGIC_VECTOR(7 downto 0);
	
	------------ CONSTANT ------------
	constant CLK_PERIOD : time := 10 ns;
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: IMC 
	PORT MAP 
		( 
			 CLOCK		=> SIM_CLOCK,
			 RAM_ADDR	=> SIM_RAM_ADDR,
			 RAM_CLK		=> SIM_RAM_CLK,
			 RAM_Q 		=> SIM_RAM_Q,
			 RAM_DATA 	=> SIM_RAM_DATA,
			 RAM_WREN 	=> SIM_RAM_WREN,
			 F_ADDR 		=> SIM_F_ADDR,
			 F_DATA 		=> SIM_F_DATA,
			 W_ADDR 		=> SIM_W_ADDR,
			 W_DATA 		=> SIM_W_DATA,
			 W_ENBL 		=> SIM_W_ENBL
		 );
		 
	------------ Start of Processes ------------	
	CLK_GEN: process
	begin
		SIM_CLOCK <= '0';
		--wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
		wait for 5ns;
		SIM_CLOCK <= '1';
		--wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
		wait for 5ns;
	end process;
	
	SIM_F_ADDR <= "000000000001010";
	SIM_W_ADDR <= "000000000001100";
	
--	-- read from address 0xA, write to address 0xC
--	stimulus: PROCESS 
--	variable counter : INTEGER := 0;
--	BEGIN
--		if falling_edge(SIM_CLOCK) then -- test read and write
--			SIM_F_ADDR <= "000000000001010";
--			SIM_W_ADDR <= "000000000001100";
----			if (counter = 0) then
----				
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			elsif (counter = 1) then
----			
----			else
----				counter := 0;
----			end if;
--		end if;
--		wait;
--	end process;
	
END simulate;