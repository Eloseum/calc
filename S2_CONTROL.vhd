library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity S2_CONTROL is
    Port 
	 ( 
		CLOCK		: IN STD_LOGIC;
		CONTROL	: IN UNSIGNED(7 downto 0); -- from stage 1
		ALU_IN2	: IN UNSIGNED(15 downto 0); -- second alu data input
		IMM_16	: OUT UNSIGNED(15 downto 0) -- from IMC and stage 1
	 );
end S2_CONTROL;

architecture Behavioral of S2_CONTROL is 

------------ Start of Design ------------
begin

	CONTROLLER: process(CLOCK)
	begin
		if rising_edge(CLOCK) then
			if ((CONTROL = x"04") or (CONTROL = x"05")) then
				ALU_IN2 <= IMM_16;
			else
				--ALU_IN2 <= 
			end if;
		end if;
	end process;


end Behavioral; 