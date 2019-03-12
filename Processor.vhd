library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.GaimBoiLibrary.ALL;

entity Processor is
    Port 
	 ( 
		ADDRESS	: BUFFER STD_LOGIC_VECTOR(15 downto 0);
		DATA		: INOUT STD_LOGIC_VECTOR(7 downto 0);
		CLOCK		: IN STD_LOGIC; 	-- ACTIVE LOW
		INT		: IN STD_LOGIC; 	-- ACTIVE LOW
		NMI		: IN STD_LOGIC; 	-- ACTIVE LOW
		HALT		: OUT STD_LOGIC; 	-- ACTIVE LOW
		MREQ		: OUT STD_LOGIC; 	-- ACTIVE LOW
		IORQ		: BUFFER STD_LOGIC; 	-- ACTIVE LOW 
		RD			: BUFFER STD_LOGIC;	-- ACTIVE LOW
		WR			: BUFFER STD_LOGIC; 	-- ACTIVE LOW
		BUSAK		: OUT STD_LOGIC; 	-- ACTIVE LOW
		WAET		: IN STD_LOGIC; 	-- ACTIVE LOW
		BUSRQ		: IN STD_LOGIC; 	-- ACTIVE LOW
		RESET		: IN STD_LOGIC; 	-- ACTIVE LOW
		MI			: BUFFER STD_LOGIC; 	-- ACTIVE LOW
		RFSH		: OUT STD_LOGIC 	-- ACTIVE LOW
	 );
end Processor;

architecture Structural of Processor is
	
	------------ Type Declarations ------------
	type RA is array (7 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	------------ Signal Declarations ------------
	signal DEBUG_REGISTERS 	: RA; -- := (x"0100", x"0000", x"0504", x"0706", x"0908", X"0B0A", x"0000", x"0F0E");
	signal RAM_CLK 	: STD_LOGIC := '1';
	signal RAM_WR  	: STD_LOGIC := '1';
	signal RAM_DATA	: STD_LOGIC_VECTOR(7 downto 0);
	signal RAM_Q		: STD_LOGIC_VECTOR(7 downto 0);
	------------ Start of Design ------------
begin

	------------ Component Instantiations ------------

	Processor: process(CLOCK)
	variable counter 		: INTEGER := 0;
	variable DATA_IN		: STD_LOGIC_VECTOR(7 downto 0);
	variable PREFIX_CB 	: STD_LOGIC := '1';
	variable FLAGS			: STD_LOGIC_VECTOR(16 downto 0);
	variable AF				: STD_LOGIC_VECTOR(15 downto 0);
	variable BC				: STD_LOGIC_VECTOR(15 downto 0);
	variable DE				: STD_LOGIC_VECTOR(15 downto 0);
	variable HL				: STD_LOGIC_VECTOR(15 downto 0);
	variable SP				: STD_LOGIC_VECTOR(15 downto 0);
	variable PC				: STD_LOGIC_VECTOR(15 downto 0);
	variable REGISTERS 	: RA := (x"0100", x"0000", x"0000", x"1000", x"0908", X"0B0A", x"0CAE", x"1F0E");
	variable REG_INDEX	: INTEGER := 0;
	variable REG_POINT	: INTEGER := 0;
	variable PC_SAV		: STD_LOGIC_VECTOR(15 downto 0);
	variable IDK			: STD_LOGIC_VECTOR(13 downto 0);
	variable POP			: STD_LOGIC := '0';
	variable PUSH			: STD_LOGIC := '0';
	variable CALL			: STD_LOGIC := '0';
	variable TEMP			: STD_LOGIC_VECTOR(15 downto 0);
	variable LD_OP			: INTEGER := 0;
	variable WB_8			: STD_LOGIC := '0';
	variable IO_8			: STD_LOGIC_VECTOR(7 downto 0);
	variable DI				: STD_LOGIC := '0';
	variable LD_HL			: STD_LOGIC := '0';
	variable SKIP			: STD_LOGIC := '0';
	variable INTERRUPT	: STD_LOGIC := '0';
	variable LDH_OUT		: STD_LOGIC := '0';
	variable LDH_IN		: STD_LOGIC := '0';
	variable IP				: STD_LOGIC := '0';
	variable INT_SAV		: STD_LOGIC_VECTOR(15 downto 0);
	variable LDH_LD		: STD_LOGIC := '0';
	variable temp_add		: STD_LOGIC_VECTOR(15 downto 0);
	begin
		if falling_edge(CLOCK) then
			DEBUG_REGISTERS(0) <= REGISTERS(0);
			DEBUG_REGISTERS(1) <= REGISTERS(1);
			DEBUG_REGISTERS(2) <= REGISTERS(2);
			DEBUG_REGISTERS(3) <= REGISTERS(3);
			DEBUG_REGISTERS(4) <= REGISTERS(4);
			DEBUG_REGISTERS(5) <= REGISTERS(5);
			DEBUG_REGISTERS(6) <= REGISTERS(6);
			DEBUG_REGISTERS(7) <= FLAGS(15 downto 0);
			if (RESET = '0') then
				COUNTER := 0;
				MI <= '0'; -- ???
				RD <= '1';
				WR <= '0';
				MREQ <= '0';
				DATA <= (others => 'Z');
				FLAGS := (others => '0');
				PREFIX_CB := '1';
				REG_INDEX := 0;
				DI := '0';
				LDH_OUT := '0';
				LDH_IN := '0';
				IORQ <= '0';
				IP := '0';
				REGISTERS(5) := x"0000";
				LD_HL := '0';
				LDH_LD := '0';
			else
				--begin by fetching instruction from memory
				if (COUNTER = 0) then
					if ((LDH_OUT = '1') and (RD = '0')) then -- writing to peripherals
						IORQ <= '1';
						DATA <= REGISTERS(0)(15 downto 8);
						LDH_OUT := '0';
						COUNTER := 15;
						IP := '1';
						MREQ <= '0';
					elsif ((LDH_IN = '1') and (RD = '0')) then -- reading from peripherals
						IORQ <= '1';
						LDH_IN := '0';
						COUNTER := 17;
						IP := '1';
						--RD <= '0'; -- disable IMC output
						DATA <= (others => 'Z');
					elsif ((NMI = '0') and (INTERRUPT = '0') and (IP = '0')) then -- non maskable interrupt
						INT_SAV := REGISTERS(5);
						REGISTERS(5) := x"0066";
						ADDRESS <= REGISTERS(5);
						INTERRUPT := '1';
						COUNTER := 1;
						MREQ <= '1';
					elsif ((INT = '0') and (DI = '0') and (INTERRUPT = '0') and IP = ('0')) then -- programmable interrupt
						INT_SAV := REGISTERS(5);
						REGISTERS(5) := x"0038";
						ADDRESS <= REGISTERS(5);
						INTERRUPT := '1';
						COUNTER := 1;
						MREQ <= '1';
					else
						RD <= '1'; -- enable reading from memory through IMC
						WR <= '0'; -- disable writing to memory
						IORQ <= '0';
						MREQ <= '1'; -- memory operation
						IP := '1'; -- instruction in progress
						if (POP = '1') then
							ADDRESS <= REGISTERS(4); -- update the address line with the contents of SP
						elsif (FLAGS(12) = '0') then
							ADDRESS <= REGISTERS(5); -- update address line with the contents of PC
						else
							ADDRESS <= REGISTERS(REG_INDEX);
							FLAGS(12) := '0';
						end if;
						COUNTER := 1;
					end if;
				elsif (COUNTER = 1) then
					MI <= '1';	-- update memory interface line, clock effectively
					DATA <= (others => 'Z'); -- prepare bi-directional data bus for reading
					COUNTER := 2;
				elsif (COUNTER = 2) then
					MI <= '0';
					if (FLAGS(14) = '1') then -- read update and write back
						if (FLAGS(9 downto 8) = "11") then -- immediate
							REGISTERS(6)(15 downto 8) := DATA;
							FLAGS(12) := '1';
							COUNTER := 0;
						elsif (FLAGS(9 downto 8) = "10") then -- increment
							REGISTERS(6)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(DATA)+1);
						else -- decrement
							REGISTERS(6)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(DATA)-1);
						end if;
						FLAGS(14) := '0';
						FLAGS(9 downto 8) := "00";
						COUNTER := 4; -- begin write cycle
					else
						if (FLAGS(9 downto 8) = "11") then -- load upper half of 16 bit immediate
							if (CALL = '0') then
								if (REG_INDEX = 5) then
									REGISTERS(6)(15 downto 8) := DATA;
								else
									REGISTERS(REG_INDEX)(15 downto 8) := DATA;
								end if;
							else
								TEMP(15 downto 8) := DATA;
							end if;
							if (POP = '1') then
								REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))+1); -- increment SP
							else
								REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC
							end if;
							FLAGS(9 downto 8) := "10";
							COUNTER := 0; -- begin loading next byte of immediate data
						elsif (FLAGS(9 downto 8) = "10") then	-- load lower half of 16 or lower 8 bit immediate
							if (FLAGS(13) = '0') then
								if (FLAGS(12) = '0') then
									if (CALL = '0') then
										if ((FLAGS(5) = '0') and (FLAGS(3) = '0')) then -- replace with function
											if (REG_INDEX = 5) then
												REGISTERS(REG_INDEX)(15 downto 8) := REGISTERS(6)(15 downto 8);
												REGISTERS(REG_INDEX)(7 downto 0) := DATA;
											else
												REGISTERS(REG_INDEX)(7 downto 0) := DATA;
												REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC ???
											end if;
										elsif ((FLAGS(5) = '0') and (FLAGS(3) = '1')) then -- replace with function !!! all subsequent code needs work !!!
											--REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(RAM_Q));
											if (LD_OP = 0) then -- ADD
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(DATA));
											elsif (LD_OP = 1) then -- ADC
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(DATA));
											elsif (LD_OP = 2) then -- SUB
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA));
											elsif (LD_OP = 3) then -- SBC
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA));
											elsif (LD_OP = 4) then -- AND
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8)) and UNSIGNED(DATA));
											elsif (LD_OP = 5) then -- XOR
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8)) xor UNSIGNED(DATA));
											elsif (LD_OP = 6) then -- OR
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8)) or UNSIGNED(DATA));
											elsif (LD_OP = 7) then -- CMP
												if (REGISTERS(0)(15 downto 8) = DATA) then
													FLAGS(6) := '1';
												end if;
											else
												REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))+UNSIGNED(DATA));
											end if;
											LD_OP := 0;
										end if;
									else
										TEMP(7 downto 0) := DATA;
										REGISTERS(5) := TEMP(15 downto 0);
										PUSH := '0';
										CALL := '0'; -- ???
									end if;
									if (POP = '1') then
										REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))+1); -- increment SP
										POP := '0';
									end if;
								else
									REGISTERS(6)(15 downto 8) := DATA;
									FLAGS(12) := '0';
									COUNTER := 4; -- begin write operation
								end if;
							else
								REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+UNSIGNED(DATA)); -- pc relative jump
								FLAGS(13) := '0';
							end if;
							FLAGS(9 downto 8) := "00";
							IP := '0'; -- enable interrupts
							COUNTER := 0; -- continue to fetch next instruction
						elsif (FLAGS(9 downto 8) = "01") then	-- load upper 8 bit
							if (FLAGS(12) = '0') then -- load and arithmetic
								--REGISTERS(REG_INDEX)(15 downto 8) := DATA;
								if ((REG_POINT = 0) and (REG_INDEX = 3) and (LDH_OUT = '0') and (LDH_IN = '0') and (LDH_LD = '0')) then
									REGISTERS(0)(15 downto 8) := DATA;
									if (LD_HL = '1') then
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+1);
									else
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))-1);
									end if;
								else
									if ((LDH_OUT = '0') and (LDH_IN = '0')) then
										REGISTERS(REG_INDEX)(15 downto 8) := DATA;
										LDH_LD := '0';
										--REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC ????
									elsif (LDH_OUT = '1') then
										ADDRESS(7 downto 0) <= DATA;
										RD <= '0';
									elsif (LDH_IN = '1') then
										ADDRESS(7 downto 0) <= DATA;
										RD <= '0';
									end if;
									REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC ????
								end if;
							else
								if (FLAGS(16 downto 15) = "00") then
									REGISTERS(REG_POINT)(15 downto 8) := DATA;
								elsif (FLAGS(16 downto 15) = "10") then
									if ((FLAGS(5) = '0') and (FLAGS(3) = '0')) then -- load and AND
										IDK := AND_8(REGISTERS(REG_POINT)(15 downto 8), DATA);
										REGISTERS(REG_POINT)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									elsif ((FLAGS(5) = '0') and (FLAGS(3) = '1')) then -- load XOR
										IDK := XOR_8(REGISTERS(REG_POINT)(15 downto 8), DATA);
										REGISTERS(REG_POINT)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := '0';
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									elsif ((FLAGS(5) = '1') and (FLAGS(3) = '0')) then -- load OR
										IDK := OR_8(REGISTERS(REG_POINT)(15 downto 8), DATA);
										REGISTERS(REG_POINT)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8); 
									else -- load and compare
										if (REGISTERS(REG_POINT)(15 downto 8) = DATA) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									end if;
								else
									if ((FLAGS(5) = '0') and (FLAGS(3) = '0')) then -- load and add
										REGISTERS(REG_POINT)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_POINT)(15 downto 8))+UNSIGNED(DATA));
									elsif ((FLAGS(5) = '0') and (FLAGS(3) = '1')) then -- load and add with carry
										if (FLAGS(0) = '1') then
											REGISTERS(REG_POINT)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_POINT)(15 downto 8))+UNSIGNED(DATA)+1);
											FLAGS(0) := '0';
										else
											REGISTERS(REG_POINT)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_POINT)(15 downto 8))+UNSIGNED(DATA));
										end if;
									elsif ((FLAGS(5) = '1') and (FLAGS(3) = '0')) or ((FLAGS(5) = '1') and (FLAGS(0) = '0')) then -- load and subtract
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA) > 0) then
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA));
												FLAGS(0) := '0'; -- reset carry flag
												FLAGS(6) := '0'; -- reset zero flag
											elsif ((UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA) = 0)) then
												REGISTERS(0)(15 downto 8) := x"00";
												FLAGS(6) := '1'; -- set zero flag
											else -- less than zero
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA));
												FLAGS(0) := '1'; -- set carry flag
												FLAGS(6) := '0'; -- reset zero flag
											end if;
									else -- load and subtract with carry
										if ((UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA)-1) > 0) then
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA)-1);
												FLAGS(0) := '0'; -- reset carry flag
												FLAGS(6) := '0'; -- reset zero flag
											elsif (((UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA)-1) = 0)) then
												REGISTERS(0)(15 downto 8) := x"00";
												FLAGS(6) := '1'; -- set zero flag
											else -- less than zero
												REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(DATA)-1);
												FLAGS(0) := '1'; -- set carry flag
												FLAGS(6) := '0'; -- reset zero flag
											end if;
									end if;
									FLAGS(15) := '0';
								end if;
								FLAGS(12) := '0';
							end if;
							FLAGS(9 downto 8) := "00";
							--REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC ????
							IP := '0'; -- enable interrupts
							COUNTER := 0; -- continue to fetch next instruction
						else
							DATA_IN := DATA; -- retreive data from memory
							if (FLAGS(11) = '0') then
								COUNTER := 3;
							elsif (WB_8 = '1') then
								COUNTER := 4;
								WB_8 := '0';
							else
								COUNTER := 8;
								FLAGS(11) := '0';
							end if;
							REGISTERS(5) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1); -- increment PC
							MI <= '0';
						end if;
					end if;
					if (COUNTER = 3) then -- should only be true when an instruction is being fetched
						--MREQ <= '1'; -- ???
						case DATA_IN(7 downto 4) is
							when x"0" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x00 = NOP
										-- do nothing
										--REGISTERS(7) := (others => '1');
									when x"1" => -- 0x01 = LD, BC, d16
										FLAGS(9 downto 8) := "11";
										REG_INDEX := 1;
										COUNTER := 0;
									when x"2" => -- 0x02 = LD (BC), A
										FLAGS(10) := '1';
										REG_INDEX := 1;
										REG_POINT := 0;
										COUNTER := 4;
									when x"3" => -- 0x03 = INC BC
										if (UNSIGNED(REGISTERS(1)) < x"FFFF") then
											REGISTERS(1) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1))+1);
										else
											REGISTERS(1) := x"0000";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"4" => -- 0x04 = INC B
										if (UNSIGNED(REGISTERS(1)(15 downto 8)) < x"FF") then
											REGISTERS(1)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1)(15 downto 8))+1);
										else
											REGISTERS(1)(15 downto 8) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"5" => -- 0x05 = DEC B
										if (UNSIGNED(REGISTERS(1)(15 downto 8)) = x"00") then
											REGISTERS(1)(15 downto 8) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(1)(15 downto 8)) = x"01") then
											REGISTERS(1)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(1)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1)(15 downto 8))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"6" => -- 0x06 = LD B, d8
										FLAGS(9 downto 8) := "01";
										REG_INDEX := 1;
									when x"7" => -- 0x07 = RLCA
										FLAGS(0) := REGISTERS(0)(15);
										REGISTERS(0)(15 downto 8) := (REGISTERS(0)(14 downto 8))&(REGISTERS(0)(15));
									when x"8" => -- 0x08 = LD (a16), SP
										FLAGS(9 downto 8) := "11"; -- load 16 bit immediate value
										FLAGS(11) := '1'; -- write 16 bit flag
										REG_INDEX := 6; -- load address into TMP register
										REG_POINT := 4; -- SP register
										COUNTER := 0; -- begin loading immediate data
									when x"9" => -- 0x09 = ADD HL, BC
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(1)));
										if ((UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(1))) > x"FFFF") then
											FLAGS(0) := '1';
										else
											FLAGS(0) := '0';
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"A" => -- 0x0A = LD A, (BC)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 1;
										REG_POINT := 0;
										COUNTER := 0;
									when x"B" => -- 0x0B = DEC BC
										if (REGISTERS(1) = x"0000") then
											REGISTERS(1) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 16));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (REGISTERS(1) = x"0001") then
											REGISTERS(1) := x"0000";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(1) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"C" => -- 0x0C = INC C
										if (UNSIGNED(REGISTERS(1)(7 downto 0)) < x"FF") then
											REGISTERS(1)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1)(7 downto 0))+1);
										else
											REGISTERS(1)(7 downto 0) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"D" => -- 0x0D = DEC C
										if (UNSIGNED(REGISTERS(1)(7 downto 0)) = x"00") then
											REGISTERS(1)(7 downto 0) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(1)(7 downto 0)) = x"01") then
											REGISTERS(1)(7 downto 0) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(1)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(1)(7 downto 0))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"E" => -- 0x0E = LD C, d8
										FLAGS(9 downto 8) := "10";
										REG_INDEX := 1;
									when others => -- 0x0F = RRCA
										FLAGS(0) := REGISTERS(0)(8);
										FLAGS(4) := '0'; -- reset h flag
										REGISTERS(0)(15 downto 8) := REGISTERS(0)(8)&REGISTERS(0)(15 downto 9); -- ???
								end case;
							when x"1" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x10 = STOP
										-- ???
									when x"1" => -- 0x11 = LD DE, d16
										FLAGS(9 downto 8) := "11";
										REG_INDEX := 2;
										COUNTER := 0;
									when x"2" => -- 0x12 = LD (DE), A
										FLAGS(10) := '1';
										REG_INDEX := 2;
										REG_POINT := 0;
										COUNTER := 4;
									when x"3" => -- 0x13 = INC DE
										if (UNSIGNED(REGISTERS(2)) < x"FFFF") then
											REGISTERS(2) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2))+1);
										else
											REGISTERS(2) := x"0000";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"4" => -- 0x14 INC D
										if (UNSIGNED(REGISTERS(2)(15 downto 8)) < x"FF") then
											REGISTERS(2)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2)(15 downto 8))+1);
										else
											REGISTERS(2)(15 downto 8) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"5" => -- 0x15 = DEC D
										if (UNSIGNED(REGISTERS(2)(15 downto 8)) = x"00") then
											REGISTERS(2)(15 downto 8) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(2)(15 downto 8)) = x"01") then
											REGISTERS(2)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(2)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2)(15 downto 8))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"6" => -- 0x16 = LD D, d8
										FLAGS(9 downto 8) := "01";
										REG_INDEX := 2;
										COUNTER := 0;
									when x"7" => -- 0x17 = RLA
										FLAGS(0) := REGISTERS(0)(15);
										FLAGS(4) := '0'; -- reset h flag
										REGISTERS(0)(15 downto 8) := REGISTERS(0)(14 downto 8)&REGISTERS(0)(15);
									when x"8" => -- 0x18 = JR r8
										PC_SAV := REGISTERS(5); -- ???
										FLAGS(9 downto 8) := "10"; -- load d8
										FLAGS(13) := '1'; -- relative jump flag
										COUNTER := 0;
									when x"9" => -- 0x19 = ADD HL, DE
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(2)));
										if ((UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(2))) > x"FFFF") then
											FLAGS(0) := '1';
										else
											FLAGS(0) := '0';
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"A" => -- 0x1A = LD A, (DE)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 2; -- address pointed to by DE
										REG_POINT := 0; -- register 0
										COUNTER := 0;
									when x"B" => -- 0x1B = DEC DE
										if (REGISTERS(2) = x"0000") then
											REGISTERS(2) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 16));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (REGISTERS(2) = x"0001") then
											REGISTERS(1) := x"0000";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(2) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"C" => -- 0x1C = INC E
										if (UNSIGNED(REGISTERS(1)(7 downto 0)) < x"FF") then
											REGISTERS(2)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2)(7 downto 0))+1);
										else
											REGISTERS(2)(7 downto 0) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"D" => -- 0x1D = DEC E
										if (UNSIGNED(REGISTERS(1)(7 downto 0)) = x"00") then
											REGISTERS(2)(7 downto 0) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(2)(7 downto 0)) = x"01") then
											REGISTERS(2)(7 downto 0) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(2)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(2)(7 downto 0))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"E" => -- 0x1E = LD E, d8
										FLAGS(9 downto 8) := "10";
										REG_INDEX := 2;
									when others => -- 0x1F = RRA
										FLAGS(0) := REGISTERS(0)(8);
										FLAGS(1) := '0';
										FLAGS(4) := '0';
										REGISTERS(0)(15 downto 8) := REGISTERS(0)(8)&REGISTERS(0)(15 downto 9);	
								end case;
							when x"2" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x20 = JR NZ, r8
										if (FLAGS(6) = '0') then
											PC_SAV := REGISTERS(5); -- ???
											FLAGS(9 downto 8) := "10"; -- load d8
											FLAGS(13) := '1'; -- relative jump flag
											COUNTER := 0;
										end if;
									when x"1" => -- 0x21 = LD, HL, d16
										FLAGS(9 downto 8) := "11";
										REG_INDEX := 3;
										COUNTER := 0;
									when x"2" => -- 0x22 = LD (HL+), A
										FLAGS(10) := '1';
										FLAGS(9 downto 8) := "11"; -- write and increment
										REG_INDEX := 3;
										REG_POINT := 0;
										COUNTER := 4;
									when x"3" => -- 0x23 = INC HL
										if (UNSIGNED(REGISTERS(3)) < x"FFFF") then
											REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+1);
										else
											REGISTERS(3) := x"0000";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"4" => -- 0x24 = INC H
										if (UNSIGNED(REGISTERS(3)(15 downto 8)) < x"FF") then
											REGISTERS(3)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3)(15 downto 8))+1);
										else
											REGISTERS(3)(15 downto 8) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"5" => -- 0x25 = DEC H
										if (UNSIGNED(REGISTERS(3)(15 downto 8)) = x"00") then
											REGISTERS(3)(15 downto 8) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(3)(15 downto 8)) = x"01") then
											REGISTERS(3)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(3)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3)(15 downto 8))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"6" => -- 0x26 = LD H, d8
										FLAGS(9 downto 8) := "01";
										REG_INDEX := 3;
										LDH_LD := '1';
										COUNTER := 0;
									when x"7" => -- 0x27 = DAA
										-- ???
									when x"8" => -- 0x28 = JR Z, r8
										if (FLAGS(6) = '1') then
											PC_SAV := REGISTERS(5); -- ???
											FLAGS(9 downto 8) := "10"; -- load d8
											FLAGS(13) := '1'; -- relative jump flag
											COUNTER := 0;
										end if;
									when x"9" => -- 0x29 = ADD HL, HL
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(3)));
										if ((UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(3))) > x"FFFF") then
											FLAGS(0) := '1';
										else
											FLAGS(0) := '0';
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"A" => -- 0x2A = LD A, (HL+)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 0;
										LD_HL := '1';
										COUNTER := 0;
									when x"B" => -- 0x2B = DEC HL
										if (REGISTERS(3) = x"0000") then
											REGISTERS(3) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 16));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (REGISTERS(3) = x"0001") then
											REGISTERS(3) := x"0000";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"C" => -- 0x2C = INC L
										if (UNSIGNED(REGISTERS(3)(7 downto 0)) < x"FF") then
											REGISTERS(3)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3)(7 downto 0))+1);
										else
											REGISTERS(3)(7 downto 0) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"D" => -- 0x2D = DEC L
										if (UNSIGNED(REGISTERS(3)(7 downto 0)) = x"00") then
											REGISTERS(3)(7 downto 0) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(3)(7 downto 0)) = x"01") then
											REGISTERS(3)(7 downto 0) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(3)(7 downto 0) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3)(7 downto 0))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"E" => -- 0x2E = LD L, d8
										FLAGS(9 downto 8) := "10";
										REG_INDEX := 3;
										COUNTER := 0;
									when others => -- 0x2F = CPL
										FLAGS(1) := '1';
										FLAGS(4) := '1';
										REGISTERS(0) := NOT(REGISTERS(0));
								end case;
							when x"3" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x30 = JR NC, r8
										if (FLAGS(0) = '0') then
											PC_SAV := REGISTERS(5); -- ???
											FLAGS(9 downto 8) := "10"; -- load d8
											FLAGS(13) := '1'; -- relative jump flag
											COUNTER := 0;
										end if;
									when x"1" => -- 0x31 = LD SP, d16
										FLAGS(9 downto 8) := "11";
										REG_INDEX := 4;
										COUNTER := 0;
									when x"2" => -- 0x32 = LD (HL-), A
										FLAGS(10) := '1';
										FLAGS(9 downto 8) := "11"; -- write and decrement
										REG_INDEX := 3;
										REG_POINT := 0;
										COUNTER := 4;
									when x"3" => -- 0x33 = INC SP
										if (UNSIGNED(REGISTERS(3)) < x"FFFF") then
											REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))+1);
										else
											REGISTERS(4) := x"0000";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"4" => -- 0x34 = INC (HL)
										FLAGS(9 downto 8) := "10"; -- load and increment
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(14) := '1'; -- write back flag
										REG_INDEX := 3; -- address pointed to by HL
										REG_POINT := 12; -- TEMP register
										COUNTER := 0;
									when x"5" => -- 0x35 = DEC (HL)
										FLAGS(9 downto 8) := "01"; -- load and decrement
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(14) := '1'; -- write back flag
										REG_INDEX := 3; -- address pointed to by HL
										REG_POINT := 12; -- TEMP register
										REG_POINT := 6; -- TEMP register
										COUNTER := 0;
									when x"6" => -- 0x36 = LD (HL), d8
										FLAGS(9 downto 8) := "11"; -- load with immediate
										--FLAGS(12) := '1'; -- direct addressing
										FLAGS(14) := '1'; -- write back flag
										REG_INDEX := 3; -- address pointed to by HL
										REG_POINT := 12; -- TEMP register
										COUNTER := 0;
									when x"7" => -- 0x37 = SCF
										FLAGS(0) := '1';
									when x"8" => -- 0x38 = JR C, r8
										if (FLAGS(0) = '1') then
											PC_SAV := REGISTERS(5); -- ???
											FLAGS(9 downto 8) := "10"; -- load d8
											FLAGS(13) := '1'; -- relative jump flag
											COUNTER := 0;
										end if;
									when x"9" => -- 0x39 = ADD HL, SP
										REGISTERS(3) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(4)));
										if ((UNSIGNED(REGISTERS(3))+UNSIGNED(REGISTERS(4))) > x"FFFF") then
											FLAGS(0) := '1';
										else
											FLAGS(0) := '0';
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"A" => -- 0x3A = LD A, (HL-)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 0;
										LD_HL := '0';
										COUNTER := 0;
									when x"B" => -- 0x3B = DEC SP
										if (REGISTERS(4) = x"0000") then
											REGISTERS(4) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 16));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (REGISTERS(4) = x"0001") then
											REGISTERS(4) := x"0000";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"C" => -- 0x3C = INC A
										if (UNSIGNED(REGISTERS(0)(15 downto 8)) < x"FF") then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+1);
										else
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(0) := '1'; -- set carry flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"D" => -- 0x3D = DEC A
										if (UNSIGNED(REGISTERS(0)(15 downto 8)) = x"00") then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(TO_SIGNED(-1, 8));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '1'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8)) = x"01") then
											REGISTERS(0)(7 downto 0) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-1);
											FLAGS(6) := '1'; -- reset zero flag
										end if;
										FLAGS(1) := '1'; -- add/subtract operation performed on last cycle
									when x"E" => -- 0x3E = LD A, d8
										FLAGS(9 downto 8) := "01";
										REG_INDEX := 0;
										COUNTER := 0;
									when others => -- 0x3F = CCF
										FLAGS(0) := NOT(FLAGS(0));
								end case;
							when x"4" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x40 = LD B, B
										REGISTERS(1)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"1" => -- 0x41 = LD, B, C
										REGISTERS(1)(15 downto 8) := REGISTERS(1)(7 downto 0);
									when x"2" => -- 0x42 = LD B, D
										REGISTERS(1)(15 downto 8) := REGISTERS(2)(15 downto 8);
									when x"3" => -- 0x43 = LD B, E
										REGISTERS(1)(15 downto 8) := REGISTERS(2)(7 downto 0);
									when x"4" => -- 0x44 = LD B, H
										REGISTERS(1)(15 downto 8) := REGISTERS(3)(15 downto 8);
									when x"5" => -- 0x45 = LD B, L
										REGISTERS(1)(15 downto 8) := REGISTERS(3)(7 downto 0);
									when x"6" => -- 0x46 = LD B, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 1;
										COUNTER := 0;
									when x"7" => -- 0x47 = LD B, A
										REGISTERS(1)(15 downto 8) := REGISTERS(0)(15 downto 8);
									when x"8" => -- 0x48 = LD C, B
										REGISTERS(1)(7 downto 0) := REGISTERS(1)(15 downto 8);
									when x"9" => -- 0x49 = LD C, C
										REGISTERS(1)(7 downto 0) := REGISTERS(1)(7 downto 0);
									when x"A" => -- 0x4A = LD C, D
										REGISTERS(1)(7 downto 0) := REGISTERS(2)(15 downto 8);
									when x"B" => -- 0x4B = LD C, E
										REGISTERS(1)(7 downto 0) := REGISTERS(2)(7 downto 0);
									when x"C" => -- 0x4C = LD C, H
										REGISTERS(1)(7 downto 0) := REGISTERS(3)(15 downto 8);
									when x"D" => -- 0x4D = LD C, L
										REGISTERS(1)(7 downto 0) := REGISTERS(3)(7 downto 0);
									when x"E" => -- 0x4E = LD C, (HL)
										FLAGS(9 downto 8) := "10"; -- load lower 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 1;
										COUNTER := 0;
									when others => -- 0x4F = LD C, A
										REGISTERS(1)(7 downto 0) := REGISTERS(0)(15 downto 8);
								end case;
							when x"5" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x50 = LD D, B
										REGISTERS(2)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"1" => -- 0x51 = LD, D, C
										REGISTERS(2)(15 downto 8) := REGISTERS(1)(7 downto 0);
									when x"2" => -- 0x52 = LD D, D
										REGISTERS(2)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"3" => -- 0x53 = LD D, E
										REGISTERS(2)(15 downto 8) := REGISTERS(2)(7 downto 0);
									when x"4" => -- 0x54 = LD D, H
										REGISTERS(2)(15 downto 8) := REGISTERS(3)(15 downto 8);
									when x"5" => -- 0x55 = LD D, L
										REGISTERS(2)(15 downto 8) := REGISTERS(3)(7 downto 0);
									when x"6" => -- 0x56 = LD D, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 2;
										COUNTER := 0;
									when x"7" => -- 0x57 = LD D, A
										REGISTERS(2)(15 downto 8) := REGISTERS(0)(15 downto 8);
									when x"8" => -- 0x58 = LD LD E, B
										REGISTERS(2)(7 downto 0) := REGISTERS(1)(15 downto 8);
									when x"9" => -- 0x59 = LD E, C
										REGISTERS(2)(7 downto 0) := REGISTERS(1)(7 downto 0);
									when x"A" => -- 0x5A = LD E, D
										REGISTERS(2)(7 downto 0) := REGISTERS(2)(15 downto 8);
									when x"B" => -- 0x5B = LD E, E
										REGISTERS(2)(7 downto 0) := REGISTERS(2)(7 downto 0);
									when x"C" => -- 0x5C = LD E, H
										REGISTERS(2)(7 downto 0) := REGISTERS(3)(15 downto 8);
									when x"D" => -- 0x5D = LD E, L
										REGISTERS(2)(7 downto 0) := REGISTERS(3)(7 downto 0);
									when x"E" => -- 0x5E = LD E, (HL)
										FLAGS(9 downto 8) := "10"; -- load lower 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3;
										REG_POINT := 2;
										COUNTER := 0;
									when others => -- 0x5F = LD E, A
										REGISTERS(2)(7 downto 0) := REGISTERS(0)(15 downto 8);
								end case;
							when x"6" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x60 = LD H, B
										REGISTERS(3)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"1" => -- 0x61 = LD H, C
										REGISTERS(3)(15 downto 8) := REGISTERS(1)(7 downto 0);
									when x"2" => -- 0x62 = LD H, D
										REGISTERS(3)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"3" => -- 0x63 = LD H, E
										REGISTERS(3)(15 downto 8) := REGISTERS(2)(7 downto 0);
									when x"4" => -- 0x64 = LD H, H
										REGISTERS(3)(15 downto 8) := REGISTERS(3)(15 downto 8);
									when x"5" => -- 0x65 = LD H, L
										REGISTERS(3)(15 downto 8) := REGISTERS(3)(7 downto 0);
									when x"6" => -- 0x66 = LD H, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 3; -- POINTS TO HL ASLO
										COUNTER := 0;
									when x"7" => -- 0x67 = LD H, A
										REGISTERS(3)(15 downto 8) := REGISTERS(0)(15 downto 8);
									when x"8" => -- 0x68 = LD L, B
										REGISTERS(3)(7 downto 0) := REGISTERS(1)(15 downto 8);
									when x"9" => -- 0x69 = LD L, C
										REGISTERS(3)(7 downto 0) := REGISTERS(1)(7 downto 0);
									when x"A" => -- 0x6A = LD L, D
										REGISTERS(3)(7 downto 0) := REGISTERS(2)(15 downto 8);
									when x"B" => -- 0x6B = LD L, E
										REGISTERS(3)(7 downto 0) := REGISTERS(2)(7 downto 0);
									when x"C" => -- 0x6C = LD L, H
										REGISTERS(3)(7 downto 0) := REGISTERS(3)(15 downto 8);
									when x"D" => -- 0x6D = LD L, L
										REGISTERS(3)(7 downto 0) := REGISTERS(3)(7 downto 0);
									when x"E" => -- 0x6E = LD L, (HL)
										FLAGS(9 downto 8) := "10"; -- load lower 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3; -- MEMORY ADDRESS
										REG_POINT := 3; -- REGISTER TO WRITE TO
										COUNTER := 0;
									when others => -- 0x6F = LD L, A
									REGISTERS(3)(7 downto 0) := REGISTERS(0)(15 downto 8);
								end case;
							when x"7" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x70 = LD (HL), B
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 2;
										COUNTER := 4;
									when x"1" => -- 0x71 = LD (HL), C
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 3;
										COUNTER := 4;
									when x"2" => -- 0x72 = LD (HL), D
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 4;
										COUNTER := 4;
									when x"3" => -- 0x73 = LD (HL), E
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 5;
										COUNTER := 4;
									when x"4" => -- 0x74 = LD (HL), H
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 6;
										COUNTER := 4;
									when x"5" => -- 0x75 = LD (HL), L
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 7;
										COUNTER := 4;
									when x"6" => -- 0x76 = HALT
										-- ???
									when x"7" => -- 0x77 = LD (HL), A
										FLAGS(10) := '1';
										REG_INDEX := 3;
										REG_POINT := 0;
										COUNTER := 4;
									when x"8" => -- 0x78 = LD A, B
										REGISTERS(0)(15 downto 8) := REGISTERS(1)(15 downto 8);
									when x"9" => -- 0x79 = LD A, C
										REGISTERS(0)(15 downto 8) := REGISTERS(1)(7 downto 0);
									when x"A" => -- 0x7A = LD A, D
										REGISTERS(0)(15 downto 8) := REGISTERS(2)(15 downto 8);
									when x"B" => -- 0x7B = LD A, E
										REGISTERS(0)(15 downto 8) := REGISTERS(2)(7 downto 0);
									when x"C" => -- 0x7C = LD A, H
										REGISTERS(0)(15 downto 8) := REGISTERS(3)(15 downto 8);
									when x"D" => -- 0x7D = LD A, L
										REGISTERS(0)(15 downto 8) := REGISTERS(3)(7 downto 0);
									when x"E" => -- 0x7E = LD A, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										REG_INDEX := 3; -- MEMORY ADDRESS
										REG_POINT := 0; -- REGISTER TO WRITE TO
										COUNTER := 0;
									when others => -- 0x7F = LD A, A
										REGISTERS(0)(15 downto 8) := REGISTERS(0)(15 downto 8);
								end case;
							when x"8" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x80 = ADD A, B
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(1)(15 downto 8)));
									when x"1" => -- 0x81 = ADD A, C
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(1)(7 downto 0)));
									when x"2" => -- 0x82 = ADD A, D
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(2)(15 downto 8)));
									when x"3" => -- 0x83 = ADD A, E
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(2)(7 downto 0)));
									when x"4" => -- 0x84 = ADD A, H
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(3)(15 downto 8)));
									when x"5" => -- 0x85 = ADD A, L
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(3)(7 downto 0)));
									when x"6" => -- 0x86 = ADD A, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(15) := '1'; -- load and arithmetic
										FLAGS(5) := '0';
										FLAGS(3) := '0';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
										COUNTER := 0;
									when x"7" => -- 0x87 = ADD A, A
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(0)(15 downto 8)));
									when x"8" => -- 0x88 = ADC A, B
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(1)(15 downto 8)));
									when x"9" => -- 0x89 = ADC A, C
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(1)(7 downto 0)));
									when x"A" => -- 0x8A = ADC A, D
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(2)(15 downto 8)));
									when x"B" => -- 0x8B = ADC A, E
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(2)(7 downto 0)));
									when x"C" => -- 0x8C = ADC A, H
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(3)(15 downto 8)));
									when x"D" => -- 0x8D = ADC A, L
										REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(3)(7 downto 0)));
									when x"E" => -- 0x8E = ADC A, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(15) := '1'; -- load and arithmetic
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
										COUNTER := 0;
									when others => -- 0x8F = ADC A, A
										if (FLAGS(0) = '1') then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(0)(15 downto 8))+1);
										else
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))+UNSIGNED(REGISTERS(0)(15 downto 8)));
										end if;
								end case;
							when x"9" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0x90 = SUB B
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(15 downto 8)) > 0) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(15 downto 8)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(15 downto 8)) = 0) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(15 downto 8)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"1" => -- 0x91 = SUB C
										if (UNSIGNED(REGISTERS(0)(15 downto 8)) > UNSIGNED(REGISTERS(1)(7 downto 0))) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(7 downto 0)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8)) = UNSIGNED(REGISTERS(1)(7 downto 0))) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(1)(7 downto 0)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"2" => -- 0x92 = SUB D
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(15 downto 8)) > 0) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(15 downto 8)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(15 downto 8)) = 0) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(15 downto 8)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"3" => -- 0x93 = SUB E
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(7 downto 0)) > 0) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(7 downto 0)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(7 downto 0)) = 0) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(2)(7 downto 0)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"4" => -- 0x94 = SUB H
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(15 downto 8)) > 0) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(15 downto 8)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(15 downto 8)) = 0) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(15 downto 8)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"5" => -- 0x95 = SUB L
										if (UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(7 downto 0)) > 0) then
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(7 downto 0)));
											FLAGS(0) := '0'; -- reset carry flag
											FLAGS(6) := '0'; -- reset zero flag
										elsif ((UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(7 downto 0)) = 0)) then
											REGISTERS(0)(15 downto 8) := x"00";
											FLAGS(6) := '1'; -- set zero flag
										else -- less than zero
											REGISTERS(0)(15 downto 8) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(0)(15 downto 8))-UNSIGNED(REGISTERS(3)(7 downto 0)));
											FLAGS(0) := '1'; -- set carry flag
											FLAGS(6) := '0'; -- reset zero flag
										end if;
									when x"6" => -- 0x96 = SUB (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(15) := '1'; -- load and arithmetic
										FLAGS(5) := '1';
										FLAGS(3) := '0';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
										COUNTER := 0;
									when x"7" => -- 0x97 = SUB A
										REGISTERS(0)(15 downto 8) := x"00";
										FLAGS(0) := '0';
										FLAGS(6) := '1';
									when x"8" => -- 0x98 = SBC A, B
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(15 downto 8), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"9" => -- 0x99 = SBC A, C
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(7 downto 0), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"A" => -- 0x9A = SBC A, D
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(15 downto 8), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"B" => -- 0x9B = SBC A, E
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(7 downto 0), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"C" => -- 0x9C = SBC A, H
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(15 downto 8), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"D" => -- 0x9D = SBC A, L
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(7 downto 0), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"E" => -- 0x9E = SBC A, (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(15) := '1'; -- load and arithmetic
										FLAGS(5) := '1';
										FLAGS(3) := '1';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
										COUNTER := 0;
									when others => -- 0x9F = SBC A, A
										IDK := SBC_8(REGISTERS(0)(15 downto 8), REGISTERS(0)(15 downto 8), FLAGS(0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
								end case;
							when x"A" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xA0 = AND B
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"1" => -- 0xA1 = AND C
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"2" => -- 0xA2 = AND D
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"3" => -- 0xA3 = AND E
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"4" => -- 0xA4 = AND H
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"5" => -- 0xA5 = AND L
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"6" => -- 0xA6 = AND (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(16) := '1'; -- load and arithmetic
										FLAGS(5) := '0';
										FLAGS(3) := '0';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
										COUNTER := 0;
									when x"7" => -- 0xA7 = AND A
										IDK := AND_8(REGISTERS(0)(15 downto 8), REGISTERS(0)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"8" => -- 0xA8 = XOR B
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"9" => -- 0xA9 = XOR C
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"A" => -- 0xAA = XOR D
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"B" => -- 0xAB = XOR E
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"C" => -- 0xAC = XOR H
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"D" => -- 0xAD = XOR L
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"E" => -- 0xAE = XOR (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(16) := '1'; -- load and arithmetic
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
									when others => -- 0xAF = XOR A
										IDK := XOR_8(REGISTERS(0)(15 downto 8), REGISTERS(0)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
								end case;
							when x"B" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xB0 = OR B
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"1" => -- 0xB1 = OR C
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(1)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"2" => -- 0xB2 = OR D
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"3" => -- 0xB3 = OR E
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(2)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"4" => -- 0xB4 = OR H
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"5" => -- 0xB5 = OR L
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(3)(7 downto 0));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"6" => -- 0xB6 = OR (HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(16) := '1'; -- load and arithmetic
										FLAGS(5) := '1';
										FLAGS(3) := '0';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
									when x"7" => -- 0xB7 = OR A
										IDK := OR_8(REGISTERS(0)(15 downto 8), REGISTERS(0)(15 downto 8));
										REGISTERS(0)(15 downto 8) := IDK(7 downto 0);
										FLAGS(7) := IDK(13);
										FLAGS(6) := IDK(12);
										FLAGS(4) := IDK(11);
										FLAGS(2) := IDK(10);
										FLAGS(1) := IDK(9);
										FLAGS(0) := IDK(8);
									when x"8" => -- 0xB8 = CP B
										if (REGISTERS(0)(15 downto 8) = REGISTERS(1)(15 downto 8)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"9" => -- 0xB9 = CP C
										if (REGISTERS(0)(15 downto 8) = REGISTERS(1)(7 downto 0)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"A" => -- 0xBA = CP D
										if (REGISTERS(0)(15 downto 8) = REGISTERS(2)(15 downto 8)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"B" => -- 0xBB = CP E
										if (REGISTERS(0)(15 downto 8) = REGISTERS(2)(7 downto 0)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"C" => -- 0xBC = CP H
										if (REGISTERS(0)(15 downto 8) = REGISTERS(3)(15 downto 8)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"D" => -- 0xBD = CP L
										if (REGISTERS(0)(15 downto 8) = REGISTERS(3)(7 downto 0)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
									when x"E" => -- 0xBE = CP(HL)
										FLAGS(9 downto 8) := "01"; -- load upper 8 bits of register a with immediate value
										FLAGS(12) := '1'; -- direct addressing
										FLAGS(16) := '1'; -- load and arithmetic
										FLAGS(5) := '1';
										FLAGS(3) := '1';
										REG_INDEX := 3; -- POINTS TO HL
										REG_POINT := 0; -- A register
									when others => -- 0xBF = CP A
										if (REGISTERS(0)(15 downto 8) = REGISTERS(0)(15 downto 8)) then
											FLAGS(6) := '1';
										else
											FLAGS(6) := '0';
										end if;
								end case;
							when x"C" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xC0 = RET NZ
										if (FLAGS(6) = '0') then
											REGISTERS(5) := PC_SAV;
										end if;
										COUNTER := 0;
									when x"1" => -- 0xC1 = POP BC
										FLAGS(9 downto 8) := "11";
										POP := '1';
										REG_INDEX := 1;
										COUNTER := 0;
									when x"2" => -- 0xC2 = JP NZ, a16
										if (FLAGS(6) = '0') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := REGISTERS(5);
											REG_INDEX := 5;
											COUNTER := 0;
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"3" => -- 0xC3 = JP a16
										FLAGS(9 downto 8) := "11";
										PC_SAV := REGISTERS(5);
										REG_INDEX := 5;
										COUNTER := 0;
									when x"4" => -- 0xC4 = CALL NZ, a16
										if (FLAGS(6) = '0') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1);
											REGISTERS(6) := PC_SAV;
											REG_INDEX := 5; -- points to PC
											REG_POINT := 5;
											CALL := '1';
											PUSH := '1';
											COUNTER := 8; -- start write cycle
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"5" => -- 0xC5 = PUSH BC
										REGISTERS(6) := PC_SAV;
										REG_INDEX := 4; -- points to SP
										REG_POINT := 1; -- register to save
										PUSH := '1';
										COUNTER := 8; -- start write cycle
									when x"6" => -- 0xC6 = ADD A, d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 0; -- add
									when x"7" => -- 0xC7 = RST 00H
										-- ???
									when x"8" => -- 0xC8 = RET Z
										if (FLAGS(6) = '1') then
											FLAGS(9 downto 8) := "11";
											POP := '1';
											REG_INDEX := 5;
											COUNTER := 0;
										end if;
									when x"9" => -- 0xC9 = RET
										FLAGS(9 downto 8) := "11";
										POP := '1';
										REG_INDEX := 5;
										COUNTER := 0;
									when x"A" => -- 0xCA = JP Z, a16
										if (FLAGS(6) = '1') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := REGISTERS(5);
											REG_INDEX := 5;
											COUNTER := 0;
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"B" => -- 0xCB = PREFIX CB
										-- ???
									when x"C" => -- 0xCC = CALL Z, a16
										if (FLAGS(6) = '1') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1);
											REGISTERS(6) := PC_SAV;
											REG_INDEX := 5; -- points to PC
											REG_POINT := 5;
											CALL := '1';
											PUSH := '1';
											COUNTER := 8; -- start write cycle
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"D" => -- 0xCD = CALL a16
										FLAGS(9 downto 8) := "11";
										PC_SAV := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2);
										REGISTERS(6) := PC_SAV;
										REG_INDEX := 5; -- points to PC
										REG_POINT := 5;
										CALL := '1';
										PUSH := '1';
										COUNTER := 8;
									when x"E" => -- 0xCE = ADC A, d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 1; -- add with carry
									when others => -- 9xCF = RST 08H
										-- ???
								end case;
							when x"D" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xD0 = RET NC
										if (FLAGS(0) = '0') then
											FLAGS(9 downto 8) := "11";
											POP := '1';
											REG_INDEX := 5;
											COUNTER := 0;
										end if;
									when x"1" => -- POP DE
										FLAGS(9 downto 8) := "11";
										POP := '1';
										REG_INDEX := 2;
										COUNTER := 0;
									when x"2" => -- JP NC, a16
										if (FLAGS(6) = '0') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := REGISTERS(5);
											REG_INDEX := 5;
											COUNTER := 0;
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"3" => -- 0xD3 = UNASSIGNED
										
									when x"4" => -- 0xD4 = CALL NC, a16
										if (FLAGS(6) = '0') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1);
											REGISTERS(6) := PC_SAV;
											REG_INDEX := 5; -- points to PC
											REG_POINT := 5;
											CALL := '1';
											PUSH := '1';
											COUNTER := 8; -- start write cycle
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"5" => -- 0xD5 = PUSH DE
										REGISTERS(6) := PC_SAV;
										REG_INDEX := 4; -- points to SP
										REG_POINT := 2; -- register to save
										PUSH := '1';
										COUNTER := 8; -- start write cycle
									when x"6" => -- 0xD6 = SUB d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 2; -- sub
									when x"7" => -- 0xD7 = RST 10H
										-- ???
									when x"8" => -- 0xD8 = RET C
										if (FLAGS(0) = '1') then
											FLAGS(9 downto 8) := "11";
											POP := '1';
											REG_INDEX := 5;
											COUNTER := 0;
										end if;
									when x"9" => -- 0xD9 = RETI
										REGISTERS(5) := INT_SAV;
										INTERRUPT := '0';
									when x"A" => -- 0xDA = JP C, a16
										if (FLAGS(0) = '1') then
											FLAGS(9 downto 8) := "11";
											PC_SAV := REGISTERS(5);
											REG_INDEX := 5;
											COUNTER := 0;
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"B" => -- 0xDB = UNASSIGNED
										
									when x"C" => -- 0xDC =  CALL C, a16
										if (FLAGS(0) = '1') then 
											FLAGS(9 downto 8) := "11";
											PC_SAV := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+1);
											REGISTERS(6) := PC_SAV;
											REG_INDEX := 5; -- points to PC
											REG_POINT := 5;
											CALL := '1';
											PUSH := '1';
											COUNTER := 8; -- start write cycle
										else
											REGISTERS(5) := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(5))+2));
										end if;
									when x"D" => -- 0xDD = UNASSIGNED
										
									when x"E" => -- 0xDE = SBC A, d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 3; -- sbc
									when others => -- 0xDF = RST 1 8H
										-- ???
								end case;
							when x"E" =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xE0 = LDH (a8), A (write to bi-directional data bus)
										FLAGS(9 downto 8) := "01";
										LDH_OUT := '1';
										COUNTER := 0;
									when x"1" => -- 0xE1 = POP HL
										FLAGS(9 downto 8) := "11";
										POP := '1';
										REG_INDEX := 3;
										COUNTER := 0;
									when x"2" => -- 0xE2 = LD (C), A
										-- ???
									when x"3" => -- 0xE3 = UNASSIGNED
										
									when x"4" => -- 0xE4 = UNASSIGNED
										
									when x"5" => -- 0xE5 = PUSH HL
										REGISTERS(6) := PC_SAV;
										REG_INDEX := 4; -- points to SP
										REG_POINT := 3; -- register to save
										PUSH := '1';
										COUNTER := 8; -- start write cycle
									when x"6" => -- 0xE6 = AND d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 4; -- AND
									when x"7" => -- 0xE7 = RST 20H
										-- ???
									when x"8" => -- 0xE8 = ADD SP, r8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 8; -- ADD signed 8 bit to stack pointer
									when x"9" => -- 0xE9 = JP (HL)
										PC_SAV := REGISTERS(5);
										REGISTERS(5) := REGISTERS(3);
									when x"A" => -- 0xEA = LD (a16), A
										FLAGS(9 downto 8) := "11"; -- load 16 bit immediate value
										WB_8 := '1'; -- write 8 bit flag
										REG_INDEX := 6; -- load address into TMP register
										REG_POINT := 0; -- A register
										COUNTER := 0; -- begin loading immediate data
									when x"B" => -- 0xEB = UNASSIGNED
										
									when x"C" => -- 0xEC = UNASSIGNED
										
									when x"D" => -- 0xED = UNASSIGNED
										
									when x"E" => -- 0xEE = XOR d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 5; -- xor
									when others => -- 0xEF = RST 2 8H
										-- ???
								end case;
							when others =>
								case DATA_IN(3 downto 0) is
									when x"0" => -- 0xF0 = LDH A, (a8) (read from bi-directional data bus)
										FLAGS(9 downto 8) := "01";
										LDH_IN := '1';
										COUNTER := 0;
									when x"1" => -- 0xF1 = POP AF
										FLAGS(9 downto 8) := "11";
										POP := '1';
										REG_INDEX := 0;
										COUNTER := 0;
									when x"2" => -- 0xF2 = LD A, (C)
										-- ???
									when x"3" => -- 0xF3 = DI
										DI := '1';
									when x"4" => -- 0xF4 = UNASSIGNED
										
									when x"5" => -- 0xF5 = PUSH AF
										REGISTERS(6) := PC_SAV;
										REG_INDEX := 4; -- points to SP
										REG_POINT := 0; -- register to save
										PUSH := '1';
										COUNTER := 8; -- start write cycle
									when x"6" => -- 0xF6 = OR d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 6; -- or
									when x"7" => -- 0xF7 = RST 30H
										-- ???
									when x"8" => -- 0xF8 = LD HL, SP+r8
										-- ???
									when x"9" => -- 0xF9 = LD SP, HL
										REGISTERS(4) := REGISTERS(3);
									when x"A" => -- 0xFA = LD A, (a16)
										
									when x"B" => -- 0xFB = EI
										DI := '0';
									when x"C" => -- 0xFC = UNASSIGNED
										
									when x"D" => -- 0xFD = UNASSIGNED
										
									when x"E" => -- 0xFE = CP d8
										FLAGS(9 downto 8) := "10";
										FLAGS(5) := '0';
										FLAGS(3) := '1';
										REG_INDEX := 0;
										LD_OP := 7; -- cp
									when others => -- 0xFF = RST 38H
										-- ???
								end case;
						end case;
						--MREQ <= '0';
					end if;
				elsif (COUNTER = 3) then
					--MREQ <= '0';
					COUNTER := 0; -- begin fetch cycle
				elsif (COUNTER = 4) then -- begin write cycle
					RD <= '0'; -- enable writing to memory through IMC
					ADDRESS <= REGISTERS(REG_INDEX);
					if (FLAGS(9 downto 8) = "11") then -- write and increment
						REGISTERS(REG_INDEX) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_INDEX))+1);
						FLAGS(9 downto 8) := "00";
					elsif (FLAGS(9 downto 8) = "10") then -- write and decrement
						REGISTERS(REG_INDEX) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_INDEX))-1);
						FLAGS(9 downto 8) := "00";
					end if;
					COUNTER := 5;
				elsif (COUNTER = 5) then
					if (REG_POINT mod 2 = 0) then
						DATA <= REGISTERS(REG_POINT/2)(15 downto 8);
					else
						DATA <= REGISTERS(REG_POINT/2)(7 downto 0);
					end if;
					WR <= '1'; -- enable writing
					COUNTER := 6;
				elsif (COUNTER = 6) then
					MI <= '1'; -- clock the data in
					COUNTER := 7; 
				elsif (COUNTER = 7) then
					WR <= '0';
					MI <= '0';
					IP := '0'; -- enable interrupts
					COUNTER := 0;
				elsif (COUNTER = 8) then -- 16 bit write
					RD <= '0'; -- enable writing to memory through IMC
					if (PUSH = '0') then
						ADDRESS <= REGISTERS(REG_INDEX);
					else
						ADDRESS <= REGISTERS(4); -- stack pointer
						REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))-1); -- update stack pointer
					end if;
					WR <= '1'; -- enable writing
					COUNTER := 9;
				elsif (COUNTER = 9) then
					temp_add := (STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_POINT))+2));
					DATA <= temp_add(15 downto 8);
					COUNTER := 10;
				elsif (COUNTER = 10) then
					MI <= '1'; -- clock the data in
					COUNTER := 11;
				elsif (COUNTER = 11) then
					if (PUSH = '0') then
						ADDRESS <= STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(REG_INDEX))+1);
					else
						ADDRESS <= REGISTERS(4);
						REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))-1); -- update stack pointer
					end if;
					MI <= '0';
					COUNTER := 12;
				elsif (COUNTER = 12) then
					--REGISTERS(4) := STD_LOGIC_VECTOR(UNSIGNED(REGISTERS(4))-1);
					DATA <= temp_add(7 downto 0 );
					COUNTER := 13;
				elsif (COUNTER = 13) then
					MI <= '1'; -- clock the data in
					COUNTER := 14;
				elsif (COUNTER = 14) then
					MI <= '0';
					WR <= '1';
					IP := '0'; -- enable interrupts
					COUNTER := 0; -- fetch next instruction
				elsif (COUNTER = 15) then -- rising edge of WR for OUT oeprations
					WR <= '1';
					COUNTER := 16;
				elsif (COUNTER = 16) then
					--DATA <= (others => 'Z');
					COUNTER := 20;
				elsif (COUNTER = 20) then
					DATA <= (others => 'Z');
					COUNTER := 0;
				elsif (COUNTER = 17) then -- read from peripheral
					DATA <= (others => 'Z');
					BUSAK <= '1';
					IP := '0'; -- enable interrupts
					COUNTER := 18;
				elsif (COUNTER = 18) then
					BUSAK <= '0';
					REGISTERS(0)(15 downto 8) := DATA;
					COUNTER := 19;
				elsif (COUNTER = 19) then
					COUNTER := 0;
				end if;
			end if;
		end if;
	end process;
	
end Structural; 