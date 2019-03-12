library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity S2_RF is
    Port 
	 ( 
		CLOCK		: IN STD_LOGIC; -- 3 clocks within a 8.4mhz cycle
		CONTROL	: IN INTEGER range 0 to 63;
		TARGETA	: IN UNSIGNED(2 downto 0);
		TARGETB	: IN UNSIGNED(2 downto 0);
		OUTA		: OUT STD_LOGIC_VECTOR(15 downto 0);
		OUTB		: OUT STD_LOGIC_VECTOR(15 downto 0)
	 );
end S2_RF;

architecture Behavioral of S2_RF is 

------------ Type Declarations ------------
type RA is array (3 downto 0) of UNSIGNED(15 downto 0);
------------ Signal Declarations ------------
signal REGISTERS  : RA := (x"00", x"00", x"00", x"00", x"00", X"00", x"00", x"00");
------------ Start of Design ------------
begin

	REGISTER_FILE: process(CLOCK)
	begin
		if rising_edge(CLOCK) then
			
		end if;
	end process;

end Behavioral; 