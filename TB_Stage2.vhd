library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY TB_Stage2 is
END TB_Stage2;

ARCHITECTURE simulate OF TB_Stage2 IS
----------------------------------------------------
--- The parent design, IMC, is instantiated
--- in this testbench. Note the component
--- declaration and the instantiation.
----------------------------------------------------
	COMPONENT Stage2
		PORT	
		 ( 
			CLOCK		: IN STD_LOGIC;
			ALU_OPC	: IN STD_LOGIC_VECTOR(7 downto 0);
			ALU_IN1	: IN UNSIGNED(15 downto 0);
			ALU_IN2	: IN UNSIGNED(15 downto 0);
			IMM_DAT	: IN UNSIGNED(15 downto 0);
			ALU_OUT	: BUFFER UNSIGNED(19 downto 0)
		 );
	END COMPONENT;

	------------ INPUTS ------------
	SIGNAL SIM_CLOCK 			: STD_LOGIC := '0';
	SIGNAL SIM_ALU_OPC 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL SIM_ALU_IN1 		: UNSIGNED(15 downto 0) := (others => '0');
	SIGNAL SIM_ALU_IN2	 	: UNSIGNED(15 downto 0) := (others => '0');
	------------ OUTPUTS ------------
	SIGNAL SIM_ALU_OUT		: UNSIGNED(19 downto 0) := (others => '0');
	------------ CONSTANT ------------
	constant CLK_PERIOD : time := 5 ns;
	
BEGIN
	
	------------ Start of Simulation ------------
	uut: Stage2
	PORT MAP 
		( 			
			CLOCK			=> SIM_CLOCK,
			ALU_OPC		=> SIM_ALU_OPC,
			ALU_IN1		=>	SIM_ALU_IN1,
			ALU_IN2		=> SIM_ALU_IN2,
			IMM_DAT		=> x"ABCD",
			ALU_OUT		=> SIM_ALU_OUT
		 );
		 
	------------ Start of Processes ------------
	CLK_GEN: process
	variable delay : STD_LOGIC := '0';
	begin
		SIM_CLOCK <= '0';
		wait for 25 ns;
		SIM_CLOCK <= '1';
		wait for 25 ns;
	end process;
	
	STIM_PROC: process
	variable counter : INTEGER := 0;
	begin
		SIM_ALU_OPC <= x"00"; -- NOP
		SIM_ALU_IN1 <= x"0000";
		SIM_ALU_IN2 <= x"0000";
		wait for 50 ns;
		SIM_ALU_OPC <= x"01"; -- INCREMENT
		SIM_ALU_IN1 <= x"0000";
		SIM_ALU_IN2 <= x"0000";
		wait for 50 ns;
		SIM_ALU_OPC <= x"02"; -- DECREMENT
		SIM_ALU_IN1 <= x"0001";
		SIM_ALU_IN2 <= x"000A";
		wait for 50 ns;
		SIM_ALU_OPC <= x"03"; -- ADD
		wait for 50 ns;
		SIM_ALU_OPC <= x"04"; -- ADD WITH CARRY
		wait for 50 ns;
		SIM_ALU_OPC <= x"05"; -- SUB
		wait for 50 ns;
		SIM_ALU_OPC <= x"06"; -- SUB WITH CARRY
		wait for 50 ns;
		SIM_ALU_OPC <= x"07"; -- AND
		wait for 50 ns;
		SIM_ALU_OPC <= x"08"; -- OR
		wait for 50 ns;
		SIM_ALU_OPC <= x"09"; -- XOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"0A"; -- COMPARE
		wait for 50 ns;
		SIM_ALU_OPC <= x"0B"; -- ROTATE LEFT
		wait for 50 ns;
		SIM_ALU_OPC <= x"0C"; -- ROTATE LEFT ACCUMULATOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"0D"; -- ROTATE LEFT THROUGH CARRY
		wait for 50 ns;
		SIM_ALU_OPC <= x"0E"; -- ROTATE LEFT THROUGH CARRY ACCUMULATOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"0F"; -- ROTATE LEFT DIGIT
		wait for 50 ns;
		SIM_ALU_OPC <= x"10"; -- ROTATE RIGHT
		wait for 50 ns;
		SIM_ALU_OPC <= x"11"; -- ROTATE RIGHT ACCUMULATOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"12"; -- ROTATE RIGHT CIRCULAR
		wait for 50 ns;
		SIM_ALU_OPC <= x"13"; -- ROTATE RIGHT CIRCULAR ACCUMULATOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"14"; -- ROTATE RIGHT DIGIT
		wait for 50 ns;
		SIM_ALU_OPC <= x"15"; -- SHIFT LEFT ARITHMETIC
		wait for 50 ns;
		SIM_ALU_OPC <= x"16"; -- SHIFT RIGHT ARITHMETIC
		wait for 50 ns;
		SIM_ALU_OPC <= x"17"; -- SHIFT RIGHT LOGICAL
		wait for 50 ns;
		SIM_ALU_OPC <= x"18"; -- COMPLEMENT ACCUMULATOR
		wait for 50 ns;
		SIM_ALU_OPC <= x"19"; --SET CARRY FLAG
		wait for 50 ns;
		SIM_ALU_OPC <= x"1A"; -- COMPLEMENT CARRY FLAG
		wait for 50 ns;
		SIM_ALU_OPC <= x"1B"; -- SET BIT
		wait for 50 ns;
		SIM_ALU_OPC <= x"1C"; -- RESET BIT
		wait;
	end process;
	
END simulate;