library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity S2_ALU is
    Port 
	 ( 
		CLOCK		: IN STD_LOGIC;
		ALU_OPC	: IN STD_LOGIC_VECTOR(7 downto 0);
		ALU_IN1	: IN UNSIGNED(15 downto 0);
		ALU_IN2	: IN UNSIGNED(15 downto 0);
		ALU_OUT	: BUFFER UNSIGNED(19 downto 0)
	 );
end S2_ALU;

architecture Behavioral of S2_ALU is 

------------ Signal Declarations ------------
------------ Start of Design ------------
begin

	ALU: process(CLOCK)
	variable temp : UNSIGNED(19 downto 0);
	begin
		if rising_edge(CLOCK) then
			case ALU_OPC is
				when x"00" => -- NOP
					-- do nothing
				when x"01" => -- INCREMENT
					ALU_OUT(16 downto 0) <= (('0' & ALU_IN1) + 1);
				when x"02" => -- DECREMENT
					if (ALU_IN1 = x"0000") then
						ALU_OUT(16 downto 0) <= (('1')&(x"0000")); -- set carry  flag on borrow out
					else
						ALU_OUT(16 downto 0) <= (('0' & ALU_IN1) - 1);
					end if;
				when x"03" => -- ADD
					ALU_OUT(16 downto 0) <= (('0' & ALU_IN1)+('0' & ALU_IN2));
				when x"04" => -- ADD WITH CARRY
					if (ALU_OUT(16) = '1') then
						ALU_OUT(16 downto 0) <= (('0' & ALU_IN1) + ('0' & ALU_IN2) + 1);
					else
						ALU_OUT(16 downto 0) <= (('0' & ALU_IN1) + ('0' & ALU_IN2));
					end if;
				when x"05" => -- SUBTRACT
					if (ALU_IN1 < ALU_IN2) then -- set carry flag on borrow out
						ALU_OUT(16 downto 0) <= (('1')&(ALU_IN1-ALU_IN2)); 
					else
						ALU_OUT(16 downto 0) <= ('0' & (ALU_IN1-ALU_IN2));
					end if;
				when x"06" => -- SUBTRACT WITH CARRY
					if (ALU_OUT(16) = '1') then -- set carry flag on borrow out
						ALU_OUT(16 downto 0) <= (('0')&(ALU_IN1-ALU_IN2-1)); 
					else
						ALU_OUT(16 downto 0) <= ('0' & (ALU_IN1-ALU_IN2));
					end if;
				when x"07" => -- AND
					ALU_OUT(15 downto 0) <= (ALU_IN1 and ALU_IN2);
				when x"08" => -- OR
					ALU_OUT(15 downto 0) <= (ALU_IN1 or ALU_IN2);
				when x"09" => -- XOR
					ALU_OUT(15 downto 0) <= (ALU_IN1 xor ALU_IN2);
				when x"0A" => -- COMPARE
					if (ALU_IN1 = ALU_IN2) then
						ALU_OUT <= (ALU_OUT or x"2000");
					else
						ALU_OUT <= (ALU_OUT and x"DFFFF");
					end if;
				when x"0B" => -- ROTATE LEFT
					temp(16 downto 0) := (ALU_OUT(16) & ALU_IN1);
					temp(16 downto 0) := (temp(16 downto 0) rol 1);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"0C" => -- ROTATE LEFT THROUGH ACCUMULATOR
					temp(16 downto 0) := (ALU_OUT(16) & ALU_IN1);
					temp(16 downto 0) := (temp(16 downto 0) rol 1);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"0D" => -- ROTATE LEFT THROUGH CARRY
					temp(0) := (ALU_IN1(15)); -- save left most bit
					ALU_OUT(16 downto 0) <= ((temp(0))&(ALU_IN1 rol 1));
				when x"0E" => -- ROTATE LEFT THROUGH CARRY ACCUMULATOR
					temp(0) := (ALU_IN1(15)); -- save left most bit
					ALU_OUT(16 downto 0) <= ((temp(0))&(ALU_IN1 rol 1));
				when x"0F" => -- ROTATE LEFT DIGIT
					temp := ((ALU_IN2(3 downto 0) & ALU_IN1) rol 4);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"10" => -- ROTATE RIGHT
					temp(16 downto 0) := (ALU_IN1 & ALU_OUT(16));
					temp(16 downto 0) := (temp(16 downto 0) rol 1);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"11" => -- ROTATE RIGHT ACCUMULATOR
					temp(16 downto 0) := (ALU_IN1 & ALU_OUT(16));
					temp(16 downto 0) := (temp(16 downto 0) ror 1);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"12" => -- ROTATE RIGHT CIRCULAR
					temp(0) := (ALU_IN1(0)); -- save right most bit
					ALU_OUT(16 downto 0) <= ((temp(0))&(ALU_IN1 ror 1));
				when x"13" => -- ROTATE RIGHT CIRCULAR ACCUMULATOR
					temp(0) := (ALU_IN1(0)); -- save right most bit
					ALU_OUT(16 downto 0) <= ((temp(0))&(ALU_IN1 ror 1));
				when x"14" => -- ROTATE RIGHT DIGIT
					temp := ((ALU_IN2(3 downto 0) & ALU_IN1) ror 4);
					ALU_OUT(16 downto 0) <= temp(16 downto 0);
				when x"15" => -- SHIFT LEFT ARITHMETIC
					--ALU_OUT(16 downto 0) <= (SHIFT_LEFT('0' & ALU_IN1), 1);
					ALU_OUT(16 downto 0) <= (ALU_IN1(15 downto 0) & '0');
				when x"16" => -- SHIFT RIGHT ARITHMETIC
					temp(0) := ALU_IN1(15);
					temp(1) := ALU_IN1(0);
					if (temp(0) = '1') then
						--ALU_OUT(16 downto 0) <= (x"8000" or (SHIFT_RIGHT(ALU_IN1), 1));
						ALU_OUT(16 downto 0) <= (temp(1) & '1' & ALU_IN1(15 downto 1));
					else
						--ALU_OUT(16 downto 0) <= (x"EFFF" and (SHIFT_RIGHT(ALU_IN1), 1));
						ALU_OUT(16 downto 0) <= (temp(1) & '0' & ALU_IN1(15 downto 1));
					end if;
				when x"17" => -- SHIFT RIGHT LOGICAL
					--ALU_OUT(16 downto 0) <= (x"EFFF" and (SHIFT_RIGHT(ALU_IN1), 1));
					temp(0) := ALU_IN1(0);
					ALU_OUT(16 downto 0) <= (temp(0) & '0' & ALU_IN1(15 downto 1));
				when x"18" => -- COMPLEMENT ACCUMULATOR
					ALU_OUT(15 downto 0) <= NOT(ALU_IN1);
				when x"19" => -- SET CARRY FLAG
					ALU_OUT(16) <= '1';
				when x"1A" => -- COMPLEMENT CARRY FLAG
					ALU_OUT(16) <= NOT(ALU_OUT(16));
				when x"1B" => -- SET BIT
					ALU_OUT(15 downto 0) <= (ALU_OUT(15 downto 0) or ALU_IN1);
				when x"1C" => -- RESET BIT
					-- ???
				when others =>
			end case;
		end if;
	end process;


end Behavioral; 