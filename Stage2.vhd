library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Stage2 is
    Port 
	 ( 
		CLOCK		: IN STD_LOGIC;
		ALU_OPC	: IN STD_LOGIC_VECTOR(7 downto 0);
		ALU_IN1	: IN UNSIGNED(15 downto 0);
		ALU_IN2	: IN UNSIGNED(15 downto 0);
		IMM_DAT	: IN UNSIGNED(15 downto 0);
		ALU_OUT	: BUFFER UNSIGNED(19 downto 0);
		PC_OUT	: OUT UNSIGNED(15 downto 0)
	 );

end Stage2;

architecture Behavioral of Stage2 is 

	------------ Component Declarations ------------
	COMPONENT S2_ALU is
		PORT 
		( 
			CLOCK		: IN STD_LOGIC;
			ALU_OPC	: IN STD_LOGIC_VECTOR(7 downto 0);
			ALU_IN1	: IN UNSIGNED(15 downto 0);
			ALU_IN2	: IN UNSIGNED(15 downto 0);
			ALU_OUT	: BUFFER UNSIGNED(19 downto 0)
		);
	END COMPONENT;
	
	COMPONENT RegisterFile is
		PORT 
		( 
			RD_CLOCK		: IN STD_LOGIC;
			WR_CLOCK		: IN STD_LOGIC;
			TARGET_A		: IN UNSIGNED(3 downto 0);
			TARGET_B		: IN UNSIGNED(3 downto 0);
			TARGET_W		: IN UNSIGNED(3 downto 0);
			DATA_W		: IN UNSIGNED(19 downto 0);
			IMM_16		: IN UNSIGNED(15 downto 0);
			OUT_A			: OUT UNSIGNED(15 downto 0);
			OUT_B			: OUT UNSIGNED(15 downto 0);
			PC_OUT		: OUT UNSIGNED(15 downto 0) -- to imc?
		);
	END COMPONENT;

------------ Signal Declarations ------------
	signal PC : UNSIGNED(15 downto 0);
	signal WIRE_ALU_IN1 : UNSIGNED(15 downto 0);
	signal WIRE_ALU_IN2 : UNSIGNED(15 downto 0);
	signal WIRE_DATA_W : UNSIGNED(15 downto 0);
------------ Start of Design ------------
begin

	ALU: S2_ALU
	PORT MAP
		( 
			CLOCK			=> CLOCK,
			ALU_OPC		=> ALU_OPC,
			ALU_IN1		=> ALU_IN1,
			ALU_IN2		=> ALU_IN2,
			ALU_OUT		=> ALU_OUT
		 );
		 
--	Registers: RegisterFile
--	PORT MAP
--		( 
--			RD_CLOCK		=> CLOCK,
--			WR_CLOCK		=> CLOCK,
--			TARGET_A		=> ALU_IN1,
--			TARGET_B		=> ALU_IN2,
--			TARGET_W		=> WIRE_DATA_W,
--			DATA_W		=> ALU_OUT,
--			IMM_16		=> IMM_DAT,
--			OUT_A			=> WIRE_ALU_IN1,
--			OUT_B			=> WIRE_ALU_IN2,
--			PC_OUT		=> PC_OUT
--		 );

end behavioral; 