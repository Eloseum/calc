library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity S1_Decoder is
    Port 
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
end S1_Decoder;

architecture Behavioral of S1_Decoder is 

------------ Signal Declarations ------------
signal PREFIX_CB : STD_LOGIC := '0';
------------ Start of Design ------------
begin

	DECODE: process(CLOCK)
	begin
		if rising_edge(CLOCK) then
			if (PREFIX_CB = '0') then
				case DATA_IN(7 downto 4) is
					when x"0" =>
						case DATA_IN(3 downto 0) is
							when x"0" => -- 0x00 = NOP
								CONTROL <= X"00";
								ALU_OPC <= X"00";
								TARGET_A <= (others => '0');
								TARGET_B <= (others => '0');
							when x"1" => -- 0x01 = LD, BC, immediate 16
								CONTROL <= X"05";
								ALU_OPC <= x"00";
								TARGET_A <= "0001";
								TARGET_B <= "1110"; -- imm_16
								TARGET_W <= "0001";
							when x"2" => -- 0x02 = LD (BC), A
								ALU_OPC <= X"03";
								--TARGET_A <= 
							when x"3" => -- 0x03 = INC BC
								--CONTROL <= x""
							when x"4" => -- 0x04 = INC B
								--TEST_ALU_OUTPUT <= x"04";
							when x"5" => -- 0x05 = DEC B
								--TEST_ALU_OUTPUT <= x"05";
							when x"6" => -- 0x06 = LD B, d8
								--TEST_ALU_OUTPUT <= x"06";
							when x"7" => -- 0x07 = RLCA
								--TEST_ALU_OUTPUT <= x"07";
							when x"8" => -- 0x08 = LD (a16), SP
								--TEST_ALU_OUTPUT <= x"08";
							when x"9" => -- 0x09 = ADD HL, BC
								--TEST_ALU_OUTPUT <= x"09";
							when x"A" => -- 0x0A = LD A, (BC)
								--TEST_ALU_OUTPUT <= x"0A";
							when x"B" => -- 0x0B = DEC BC
								--TEST_ALU_OUTPUT <= x"0B";
							when x"C" => -- 0x0C = INC C
								--TEST_ALU_OUTPUT <= x"0C";
							when x"D" => -- 0x0D = DEC C
								--TEST_ALU_OUTPUT <= x"0D";
							when x"E" => -- 0x0E = LD C, d8
								--TEST_ALU_OUTPUT <= x"0E";
							when x"F" => -- 0x0F = RRCA
								--TEST_ALU_OUTPUT <= x"0F";
							when others =>
								--TEST_ALU_OUTPUT <= x"FF";
						end case;
					when x"1" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"2" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"3" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"4" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"5" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"6" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"7" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"8" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"9" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"A" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"B" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"C" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"D" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"E" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when x"F" =>
						--TEST_ALU_OUTPUT <= x"FF";
					when others =>
						--TEST_ALU_OUTPUT <= x"FF";
				end case;
			else -- CB extended operations
				-- ...
			end if;
			IMM_8 <= DATA_IN;
		end if;
	end process;


end Behavioral; 
