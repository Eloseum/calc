library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_Stage1 is
END TB_Stage1;

ARCHITECTURE simulate OF TB_Stage1 IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT Stage1 is
		PORT 
		 ( 
			CLOCK			: IN STD_LOGIC; -- 3 clocks within a 8.4mhz cycle
			INSTRUCTION	: IN STD_LOGIC_VECTOR(7 downto 0)	
		 );
	END COMPONENT STAGE1;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '0';
	SIGNAL SIM_IMC_CLOCK 	: STD_LOGIC := '0';
	SIGNAL SIM_JUMP	 		: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	------------ OUTPUTS ------------
	SIGNAL SIM_Instruction 	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	------------ CONSTANT ------------
	constant CLK_PERIOD : time := 5 ns;
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: Stage1 
	PORT MAP 
		( 
			 CLOCK			=> SIM_CLOCK,
			 Instruction	=> SIM_Instruction
		 );
		 
	------------ Start of Processes ------------
	S1_CLK_GEN: process
	begin
		SIM_CLOCK <= '0';
		wait for 25 ns;
		SIM_CLOCK <= '1';
		wait for 25 ns;
	end process;
	
	STIMULUS: process(SIM_CLOCK)
	begin
		if (falling_edge(SIM_CLOCK)) then
			SIM_Instruction <= STD_LOGIC_VECTOR(UNSIGNED(SIM_INSTRUCTION)+1);
		end if;
	end process;
	
END simulate;