library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity CPU is
    Port 
	 ( 
		CLOCK0	: IN STD_LOGIC; -- CPU CLOCK
		CLOCK1	: IN STD_LOGIC; -- REGISTER CLOCK
		ADDRESS	: OUT UNSIGNED(15 downto 0);
		DATA_IN	: IN UNSIGNED(7 downto 0);
		DATA_OUT	: OUT UNSIGNED(7 downto 0);
		IO			: INOUT STD_LOGIC_VECTOR(7 downto 0);
		RESET		: IN STD_LOGIC;
		HOLD		: IN STD_LOGIC;
		INT		: IN STD_LOGIC;
		INTE		: OUT STD_LOGIC;
		DBIN		: OUT STD_LOGIC;
		WR			: OUT STD_LOGIC;
		SYNC		: OUT STD_LOGIC;
		HLDA		: OUT STD_LOGIC;
		READY		: IN STD_LOGIC;
		WAET		: OUT STD_LOGIC;
		IMC_CE	: OUT STD_LOGIC; -- IMC chip enable
		PC			: OUT UNSIGNED(15 downto 0)
	 );

end CPU;

architecture Structural of CPU is

	------------ Component Declarations ------------
	COMPONENT Stage0
		PORT 
		( 
			CLOCK			: IN STD_LOGIC;
			F_DI			: IN UNSIGNED (7 DOWNTO 0);
			F_ADDR		: OUT UNSIGNED (15 DOWNTO 0);
			IMC_CE		: OUT STD_LOGIC := '1';
			F_DO			: OUT UNSIGNED(7 downto 0);
			PC_IN			: IN UNSIGNED(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Stage1
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
	
	COMPONENT Stage2
		PORT 
		( 
			CLOCK		: IN STD_LOGIC;
			ALU_OPC	: IN STD_LOGIC_VECTOR(7 downto 0);
			ALU_IN1	: IN UNSIGNED(15 downto 0);
			ALU_IN2	: IN UNSIGNED(15 downto 0);
			IMM_DAT	: IN UNSIGNED(15 downto 0);
			ALU_OUT	: BUFFER UNSIGNED(19 downto 0);
			PC_OUT	: OUT UNSIGNED(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT RegisterFile is
    Port 
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
		PC_OUT		: OUT UNSIGNED(15 downto 0)
	 );
	END COMPONENT;
	
	------------ Signal Declarations ------------
	signal TEST_BRNTRGT	: STD_LOGIC_VECTOR(15 downto 0);
	signal WIRE_INSTR	  	: UNSIGNED(7 downto 0);
	signal WIRE_ALU_OPC	: STD_LOGIC_VECTOR(7 downto 0);
	signal WIRE_LD_STR	: UNSIGNED(7 downto 0);
	signal WIRE_TAR_A		: UNSIGNED(3 downto 0);
	signal WIRE_TAR_B		: UNSIGNED(3 downto 0);
	signal WIRE_TAR_W		: UNSIGNED(3 downto 0);
	signal WIRE_IMM_F		: UNSIGNED(7 downto 0);
	signal WIRE_IMM_D		: UNSIGNED(15 downto 0);
	signal WIRE_R_OUTA	: UNSIGNED(15 downto 0);
	signal WIRE_R_OUTB	: UNSIGNED(15 downto 0);
	signal WIRE_ALU_O		: UNSIGNED(19 downto 0);
	signal WIRE_CONTROL	: UNSIGNED(7 downto 0);
	signal WIRE_PC_OUT	: UNSIGNED(15 downto 0);
	signal WIRE_PC			: UNSIGNED(15 downto 0);
	------------ Start of Design ------------
begin

	------------ Component Instantiations ------------
	S0: Stage0
	PORT MAP
		(
			CLOCK			=> CLOCK0,
			F_DI			=> DATA_IN,
			F_ADDR		=> ADDRESS,
			IMC_CE		=> IMC_CE,
			F_DO			=> WIRE_INSTR,
			PC_IN			=> WIRE_PC_OUT
		 );
		 
	S1: Stage1
	PORT MAP
		( 			
			CLOCK			=> CLOCK0,
			DATA_IN		=> WIRE_INSTR,
			CONTROL		=> WIRE_CONTROL,
			ALU_OPC		=> WIRE_ALU_OPC,
			TARGET_A		=> WIRE_TAR_A,
			TARGET_B		=> WIRE_TAR_B,
			TARGET_W		=> WIRE_TAR_W,
			IMM_8			=> WIRE_IMM_D(15 downto 8)
		 );
		 
	S2: Stage2
	PORT MAP
		( 
			CLOCK		=> CLOCK0,
			ALU_OPC	=> WIRE_ALU_OPC,
			ALU_IN1	=> WIRE_R_OUTA,
			ALU_IN2	=> WIRE_R_OUTB,
			IMM_DAT	=> WIRE_IMM_D,
			ALU_OUT	=> WIRE_ALU_O,
			PC_OUT	=> WIRE_PC_OUT
		 );
		 
	Registers: RegisterFile
	PORT MAP
		( 
			RD_CLOCK		=> CLOCK1, -- 90 degrees out of phase with cpu clock
			WR_CLOCK		=> CLOCK1,
			TARGET_A		=> WIRE_TAR_A,
			TARGET_B		=> WIRE_TAR_B,
			TARGET_W		=> WIRE_TAR_W,
			DATA_W		=> WIRE_ALU_O,
			IMM_16		=> WIRE_IMM_D,
			OUT_A			=> WIRE_R_OUTA,
			OUT_B			=> WIRE_R_OUTB,
			PC_OUT		=> WIRE_PC
		 );
		 
end Structural; 