library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Stage1 is
    Port 
	 ( 
		CLOCK			: IN STD_LOGIC;
		DATA_IN		: IN UNSIGNED(7 downto 0); -- from stage 0
		CONTROL		: OUT UNSIGNED(7 downto 0); -- controls stage 2 output
		ALU_OPC		: OUT STD_LOGIC_VECTOR(7 downto 0); -- alu control code
		TARGET_A		: OUT UNSIGNED(3 downto 0); -- operand 1
		TARGET_B		: OUT UNSIGNED(3 downto 0); -- operand 2
		TARGET_W		: OUT UNSIGNED(3 downto 0); -- register to write to
		IMM_8			: OUT UNSIGNED(7 downto 0)
	 );

end Stage1;

architecture Structural of Stage1 is 

	------------ Component Declarations ------------
	COMPONENT S1_Decoder is
		PORT 
		( 
			CLOCK			: IN STD_LOGIC;
			DATA_IN		: IN UNSIGNED(7 downto 0);
			CONTROL		: OUT UNSIGNED(7 downto 0);
			ALU_OPC		: OUT STD_LOGIC_VECTOR(7 downto 0);
			TARGET_A		: OUT UNSIGNED(3 downto 0);
			TARGET_B		: OUT UNSIGNED(3 downto 0);
			TARGET_W		: OUT UNSIGNED(3 downto 0);
			IMM_8			: OUT UNSIGNED(7 downto 0)
		);
	END COMPONENT;
	------------ Signal Declarations ------------
	
	
	------------ Start of Design ------------
begin

	DECODER: S1_Decoder
	PORT MAP
		( 
			CLOCK				=> CLOCK,
			DATA_IN			=> DATA_IN,
			CONTROL			=> CONTROL,
			ALU_OPC			=> ALU_OPC,
			TARGET_A			=> TARGET_A,
			TARGET_B			=> TARGET_B,
			TARGET_W			=> TARGET_W,
			IMM_8				=> IMM_8
		 );

end Structural; 