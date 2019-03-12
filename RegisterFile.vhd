library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
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
		PC_OUT		: OUT UNSIGNED(15 downto 0) -- to imc?
	 );
end RegisterFile;

architecture Behavioral of RegisterFile is 

------------ Type Declarations ------------
type RA is array (7 downto 0) of UNSIGNED(15 downto 0);
------------ Signal Declarations ------------
signal REGISTERS : RA := (x"0100", x"0000", x"0504", x"0706", x"0908", X"0B0A", x"0000", x"0F0E");
------------ Start of Design ------------
begin

	------------ Stage 2 (execute) register access ------------
	S2_READ: process(RD_CLOCK)
	begin
		if rising_edge(RD_CLOCK) then
			case TARGET_A is
				when "0000" =>
					OUT_A <= (x"00")&(REGISTERS(0)(15 downto 8)); -- A
				when "0001" =>
					OUT_A <= (x"00")&(REGISTERS(1)(15 downto 8)); -- B
				when "0010" =>
					OUT_A <= (X"00FF") and (REGISTERS(1)); -- C
				when "0011" =>
					OUT_A <= (x"00")&(REGISTERS(2)(15 downto 8)); -- D
				when "0100" =>
					OUT_A <= (X"00FF") and (REGISTERS(2)); -- E
				when "0101" =>
					OUT_A <= (x"00")&(REGISTERS(3)(15 downto 8)); -- H
				when "0110" =>
					OUT_A <= (X"00FF") and (REGISTERS(3)); -- L
				when "0111" =>
					OUT_A <= REGISTERS(1); -- BC
				when "1000" =>
					OUT_A <= REGISTERS(2); -- DE
				when "1001" =>
					OUT_A <= REGISTERS(3); -- HL
				when "1010" =>
					OUT_A <= REGISTERS(4); -- BC
				when "1011" =>
					OUT_A <= REGISTERS(5); -- SP
				when "1100" =>
					OUT_A <= REGISTERS(6); -- PC
				when "1101" =>
					OUT_A <= ((x"00FF") and REGISTERS(0)); -- F
				when others =>
					--
			end case;
			case TARGET_B is
				when "0000" =>
					OUT_B <= (x"00")&(REGISTERS(0)(15 downto 8)); -- A
				when "0001" =>
					OUT_B <= (x"00")&(REGISTERS(1)(15 downto 8)); -- B
				when "0010" =>
					OUT_B <= (X"00FF") and (REGISTERS(1)); -- C
				when "0011" =>
					OUT_B <= (x"00")&(REGISTERS(2)(15 downto 8)); -- D
				when "0100" =>
					OUT_B <= (X"00FF") and (REGISTERS(2)); -- E
				when "0101" =>
					OUT_B <= (x"00")&(REGISTERS(3)(15 downto 8)); -- H
				when "0110" =>
					OUT_B <= (X"00FF") and (REGISTERS(3)); -- L
				when "0111" =>
					OUT_B <= REGISTERS(1); -- BC
				when "1000" =>
					OUT_B <= REGISTERS(2); -- DE
				when "1001" =>
					OUT_B <= REGISTERS(3); -- HL
				when "1010" =>
					OUT_B <= REGISTERS(4); -- BC
				when "1011" =>
					OUT_B <= REGISTERS(5); -- SP
				when "1100" =>
					OUT_B <= REGISTERS(6); -- PC
				when "1101" =>
					OUT_B <= ((x"00FF") and REGISTERS(0)); -- F
				when "1110" =>
					OUT_B <= ((x"00") & (IMM_16(7 downto 0)));  -- IMM_8
				when others =>
					OUT_B <= IMM_16;  -- IMM_16
			end case;
		end if;
	end process;
	
	S2_WRITE: process(WR_CLOCK)
	variable PC : UNSIGNED(15 downto 0) := (others => '0');
	begin
		if rising_edge(WR_CLOCK) then
			PC := (PC+1); -- increment value in pc
			case TARGET_W is
				when "0000" =>
					REGISTERS(0)(15 downto 8) <= DATA_W(7 downto 0); -- A
				when "0001" =>
					REGISTERS(1)(15 downto 8) <= DATA_W(7 downto 0); -- B
				when "0010" =>
					REGISTERS(1)(7 downto 0) <= DATA_W(7 downto 0); -- C
				when "0011" =>
					REGISTERS(2)(15 downto 8) <= DATA_W(7 downto 0); -- D
				when "0100" =>
					REGISTERS(2)(7 downto 0) <= DATA_W(7 downto 0); -- E
				when "0101" =>
					REGISTERS(3)(15 downto 8) <= DATA_W(7 downto 0); -- H
				when "0110" =>
					REGISTERS(3)(7 downto 0) <= DATA_W(7 downto 0); -- L
				when "0111" =>
					REGISTERS(1) <= DATA_W(15 downto 0); -- BC
				when "1000" =>
					REGISTERS(2) <= DATA_W(15 downto 0); -- DE
				when "1001" =>
					REGISTERS(3) <= DATA_W(15 downto 0); -- HL
				when "1010" =>
					REGISTERS(4) <= DATA_W(15 downto 0); -- BC
				when "1011" =>
					REGISTERS(5) <= DATA_W(15 downto 0); -- SP
				when "1100" =>
					--REGISTERS(6) <= DATA_W(15 downto 0); -- PC
					--PC := DATA_W(15 downto 0);
				when "1101" =>
					REGISTERS(7) <= DATA_W(15 downto 0); -- F
				when others =>
					-- NOP
			end case;
			if (DATA_W(16) = '1') then -- update carry flag
				REGISTERS(7)(4) <= '1';
			end if;
			REGISTERS(6) <= PC;
			--PC_OUT <= PC;
		end if;
	end process;
	------------ Stage 3 (memory access) register access ------------
	
	PC_OUT <= REGISTERS(6);

end Behavioral; 