library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity IFU is
    Port 
	 ( 
		CLOCK			: IN STD_LOGIC;
		F_DI			: IN UNSIGNED (7 DOWNTO 0); -- data read from memory
		F_ADDR		: OUT UNSIGNED (15 DOWNTO 0); -- address to read from
		IMC_CE		: OUT STD_LOGIC := '1'; -- integrated memory controller chip enable
		F_DO			: OUT UNSIGNED(7 downto 0);-- data read from memory
		PC_IN			: IN UNSIGNED(15 downto 0)
	 );

end IFU;
	
architecture Behavioral of IFU is 

	------------ Signal Declarations ------------
	signal PC : UNSIGNED(15 downto 0) := (others => '0');
	
------------ Start of Design ------------
begin
	
	FETCH: process(CLOCK)
	begin
		if rising_edge(CLOCK) then
			F_ADDR <= PC_IN;
			F_DO <= F_DI;
			IMC_CE <= '0';
		end if;
	end process;
	
end Behavioral;