library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_Processor is
END TB_Processor;

ARCHITECTURE simulate OF TB_Processor IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT Processor
		PORT	
		 ( 
			ADDRESS	: BUFFER STD_LOGIC_VECTOR(15 downto 0);
			DATA		: INOUT STD_LOGIC_VECTOR(7 downto 0);
			CLOCK		: IN STD_LOGIC; 	-- ACTIVE LOW
			INT		: IN STD_LOGIC; 	-- ACTIVE LOW
			NMI		: IN STD_LOGIC; 	-- ACTIVE LOW
			HALT		: OUT STD_LOGIC; 	-- ACTIVE LOW
			MREQ		: OUT STD_LOGIC; 	-- ACTIVE LOW
			IORQ		: OUT STD_LOGIC; 	-- ACTIVE LOW 
			RD			: BUFFER STD_LOGIC;	-- ACTIVE LOW
			WR			: BUFFER STD_LOGIC; 	-- ACTIVE LOW
			BUSAK		: OUT STD_LOGIC; 	-- ACTIVE LOW
			WAET		: IN STD_LOGIC; 	-- ACTIVE LOW
			BUSRQ		: IN STD_LOGIC; 	-- ACTIVE LOW
			RESET		: IN STD_LOGIC; 	-- ACTIVE LOW
			MI			: BUFFER STD_LOGIC; 	-- ACTIVE LOW
			RFSH		: OUT STD_LOGIC 	-- ACTIVE LOW
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
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: Processor 
	PORT MAP 
		( 
			ADDRESS	=> SIM_ADDR,
			DATA		=> SIM_DATA,
			CLOCK		=> SIM_CLOCK,
			INT		=> '1',
			NMI		=> '1',
			HALT		=> SIM_HALT,
			MREQ		=> SIM_MREQ,
			IORQ		=> SIM_IORQ,
			RD			=> SIM_RD,
			WR			=> SIM_WR,
			BUSAK		=> SIM_BUSAK,
			WAET		=> '1',
			BUSRQ		=> '1',
			RESET		=> SIM_RESET,
			MI			=> SIM_MI,
			RFSH		=> SIM_RFSH
		 );
		 
	------------ Start of Processes ------------	
	CPU_CLK_GEN: process
	variable counter : INTEGER := 0;
	begin
		SIM_CLOCK <= '0';
		wait for 5 ns;
		SIM_CLOCK <= '1';
		if (counter < 1) then
			SIM_RESET <= '0';
			counter := (counter+1);
		else
			SIM_RESET <= '1';
		end if;
		wait for 5 ns;
	end process;
	
END simulate;