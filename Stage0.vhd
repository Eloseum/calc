library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Stage0 is
   Port 
	( 
		CLOCK			: IN STD_LOGIC;
		F_DI			: IN UNSIGNED (7 DOWNTO 0); -- data read from memory
		F_ADDR		: OUT UNSIGNED (15 DOWNTO 0); -- address to read from
		IMC_CE		: OUT STD_LOGIC := '1'; -- integrated memory controller chip enable
		F_DO			: OUT UNSIGNED(7 downto 0); -- data read from memory
		PC_IN			: IN UNSIGNED(15 downto 0)
	);
end Stage0;

architecture Structural of Stage0 is

	------------ Component Declarations ------------
	COMPONENT IFU
		PORT 
		( 
			CLOCK			: IN STD_LOGIC;
			F_DI			: IN UNSIGNED (7 DOWNTO 0); -- data read from memory
			F_ADDR		: OUT UNSIGNED (15 DOWNTO 0); -- address to read from
			IMC_CE		: OUT STD_LOGIC := '1'; -- integrated memory controller chip enable
			F_DO			: OUT UNSIGNED(7 downto 0); -- data read from memory
			PC_IN			: IN UNSIGNED(15 downto 0)
		);
	END COMPONENT;

	------------ Signal Declarations ------------

------------ Start of Design ------------
begin

	------------ Component Instantiations ------------
	InstructionFetchUnit: IFU
	PORT MAP
		( 
			CLOCK		=> CLOCK,
			F_DI		=> F_DI,
			F_ADDR	=> F_ADDR,
			IMC_CE	=> IMC_CE,
			F_DO		=> F_DO,
			PC_IN		=> PC_IN
		 );
		 

end Structural; 