library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_Stage0 is
END TB_Stage0;

ARCHITECTURE simulate OF TB_Stage0 IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT Stage0
		PORT	
		(
			------------ Clock ------------
			CLOCK			: IN STD_LOGIC; -- 8.4Mhz
			IMC_CLOCK	: IN STD_LOGIC; -- 50.4Mhz
			------------ Stage Interface ------------
			Instruction	: OUT STD_LOGIC_VECTOR(7 downto 0);
			JUMP			: IN STD_LOGIC_VECTOR(15 downto 0)
		);
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '0';
	SIGNAL SIM_IMC_CLOCK 	: STD_LOGIC := '0';
	SIGNAL SIM_JUMP	 		: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	------------ OUTPUTS ------------
	SIGNAL SIM_Instruction 	: STD_LOGIC_VECTOR(7 downto 0);
	
	------------ CONSTANT ------------
	constant CLK_PERIOD : time := 5 ns;
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: Stage0 
	PORT MAP 
		( 
			 CLOCK			=> SIM_CLOCK,
			 IMC_CLOCK		=> SIM_IMC_CLOCK,
			 Instruction	=> SIM_Instruction,
			 JUMP 			=> SIM_JUMP
		 );
		 
	------------ Start of Processes ------------
	S0_CLK_GEN: process
	begin
		SIM_CLOCK <= '0';
		wait for 25ns;
		SIM_CLOCK <= '1';
		wait for 25ns;
	end process;
	
	IMC_CLK_GEN: process
	begin
		SIM_IMC_CLOCK <= '0';
		--wait for CLK_PERIOD/2;  --for half of clock period clk stays at '0'.
		wait for 5ns;
		SIM_IMC_CLOCK <= '1';
		--wait for CLK_PERIOD/2;  --for next half of clock period clk stays at '1'.
		wait for 5ns;
	end process;
	
END simulate;