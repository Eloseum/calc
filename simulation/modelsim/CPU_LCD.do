onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group PROCESSOR -radix hexadecimal /tb_top/uut/IC_0/ADDRESS
add wave -noupdate -expand -group PROCESSOR -radix hexadecimal /tb_top/uut/IC_0/DATA
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/CLOCK
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/INT
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/NMI
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/HALT
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/MREQ
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/IORQ
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/RD
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/WR
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/BUSAK
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/WAET
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/BUSRQ
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/RESET
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/RFSH
add wave -noupdate -expand -group PROCESSOR /tb_top/uut/IC_0/MI
add wave -noupdate -expand -group PROCESSOR -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(7)
add wave -noupdate -expand -group PROCESSOR -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(6)
add wave -noupdate -expand -group PROCESSOR -label PC -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(5)
add wave -noupdate -expand -group PROCESSOR -label SP -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(4)
add wave -noupdate -expand -group PROCESSOR -label HL -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(3)
add wave -noupdate -expand -group PROCESSOR -label CD -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(2)
add wave -noupdate -expand -group PROCESSOR -label BC -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(1)
add wave -noupdate -expand -group PROCESSOR -label AF -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(0)
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_top/uut/IC_1/address
add wave -noupdate -expand -group MEMORY /tb_top/uut/IC_1/clock
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_top/uut/IC_1/data
add wave -noupdate -expand -group MEMORY /tb_top/uut/IC_1/wren
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_top/uut/IC_1/q
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/CLOCK
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/RESET
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/MCU_IORQ
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/MCU_WR
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/MCU_RD
add wave -noupdate -expand -group LCD_CONTROLLER -radix hexadecimal /tb_top/uut/IC_3/MCU_DAT
add wave -noupdate -expand -group LCD_CONTROLLER -radix hexadecimal /tb_top/uut/IC_3/MCU_ADD
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/MCU_INT
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/MCU_BUSRQ
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/LCD_RST
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/LCD_CS
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/LCD_DCX
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/LCD_WR
add wave -noupdate -expand -group LCD_CONTROLLER /tb_top/uut/IC_3/LCD_RD
add wave -noupdate -expand -group LCD_CONTROLLER -radix hexadecimal /tb_top/uut/IC_3/LCD_DAT
add wave -noupdate -expand -group LCD_CONTROLLER -radix hexadecimal /tb_top/uut/IC_3/LEDR
add wave -noupdate -expand -group LCD_CONTROLLER -radix hexadecimal /tb_top/uut/IC_3/SW
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1228789 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {105 us}
