onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group S0 /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/CLOCK
add wave -noupdate -expand -group S0 -radix hexadecimal /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/F_DI
add wave -noupdate -expand -group S0 -radix hexadecimal /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/F_ADDR
add wave -noupdate -expand -group S0 /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/IMC_CE
add wave -noupdate -expand -group S0 -radix hexadecimal /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/F_DO
add wave -noupdate -expand -group S0 -radix hexadecimal /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/PC_IN
add wave -noupdate -expand -group S0 -radix hexadecimal /tb_microcontroller/uut/CPU0/S0/InstructionFetchUnit/PC
add wave -noupdate -expand -group S1 /tb_microcontroller/uut/CPU0/S1/CLOCK
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/DATA_IN
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/CONTROL
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/ALU_OPC
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/TARGET_A
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/TARGET_B
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/TARGET_W
add wave -noupdate -expand -group S1 -radix hexadecimal /tb_microcontroller/uut/CPU0/S1/IMM_8
add wave -noupdate -expand -group S2 /tb_microcontroller/uut/CPU0/S2/CLOCK
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/ALU_OPC
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/ALU_IN1
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/ALU_IN2
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/IMM_DAT
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/ALU_OUT
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/PC_OUT
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/PC
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/WIRE_ALU_IN1
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/WIRE_ALU_IN2
add wave -noupdate -expand -group S2 -radix hexadecimal /tb_microcontroller/uut/CPU0/S2/WIRE_DATA_W
add wave -noupdate -expand -group Registers /tb_microcontroller/uut/CPU0/Registers/RD_CLOCK
add wave -noupdate -expand -group Registers /tb_microcontroller/uut/CPU0/Registers/WR_CLOCK
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/TARGET_A
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/TARGET_B
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/TARGET_W
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/DATA_W
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/IMM_16
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/OUT_A
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/OUT_B
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/PC_OUT
add wave -noupdate -expand -group Registers -radix hexadecimal /tb_microcontroller/uut/CPU0/Registers/REGISTERS
add wave -noupdate -expand -group MemoryController /tb_microcontroller/uut/MemoryController/CLOCK
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/RAM_ADDR
add wave -noupdate -expand -group MemoryController /tb_microcontroller/uut/MemoryController/RAM_CLK
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/RAM_Q
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/RAM_DATA
add wave -noupdate -expand -group MemoryController /tb_microcontroller/uut/MemoryController/RAM_WREN
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/R_ADDR0
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/R_DATA0
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/R_ADDR1
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/R_DATA1
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/W_ADDR
add wave -noupdate -expand -group MemoryController -radix hexadecimal /tb_microcontroller/uut/MemoryController/W_DATA
add wave -noupdate -expand -group MemoryController /tb_microcontroller/uut/MemoryController/W_ENBL
add wave -noupdate -expand -group MemoryController /tb_microcontroller/uut/MemoryController/CE
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_microcontroller/uut/Memory/address
add wave -noupdate -expand -group Memory /tb_microcontroller/uut/Memory/clock
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_microcontroller/uut/Memory/data
add wave -noupdate -expand -group Memory /tb_microcontroller/uut/Memory/wren
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_microcontroller/uut/Memory/q
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_microcontroller/uut/Memory/sub_wire0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36207 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 253
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {525 ns}
