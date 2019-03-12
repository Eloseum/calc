library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity IMC is
    Port 
	 ( 
		WR			: IN STD_LOGIC;
		RD 		: IN STD_LOGIC;
		MREQ 		: IN STD_LOGIC;
		Q			: IN STD_LOGIC_VECTOR(7 downto 0);
		DATA		: OUT STD_LOGIC_VECTOR(7 downto 0);
		IO_8		: INOUT STD_LOGIC_VECTOR(7 downto 0)
	 );
end IMC;
	
architecture Behavioral of IMC is 

------------ Signal Declarations ------------
	
------------ Start of Design ------------
begin
	
	MemoryInterface: process(MREQ, RD, IO_8, Q)
	begin
		if (MREQ = '1') then
			if (RD = '1') then
				DATA <= (others => 'Z');
				IO_8 <= Q; 
			else
				IO_8 <= (others => 'Z');
				DATA <= IO_8;
			end if;
		end if;
	end process;

end Behavioral;