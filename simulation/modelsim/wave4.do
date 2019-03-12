onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group External /tb_top/uut/CLOCK_50
add wave -noupdate -expand -group External /tb_top/uut/CLOCK2_50
add wave -noupdate -expand -group External /tb_top/uut/CLOCK3_50
add wave -noupdate -expand -group External /tb_top/uut/CLOCK4_50
add wave -noupdate -expand -group External -radix hexadecimal /tb_top/uut/SW
add wave -noupdate -expand -group External -radix hexadecimal /tb_top/uut/KEY
add wave -noupdate -expand -group External /tb_top/uut/HEX0
add wave -noupdate -expand -group External /tb_top/uut/HEX1
add wave -noupdate -expand -group External /tb_top/uut/HEX2
add wave -noupdate -expand -group External /tb_top/uut/HEX3
add wave -noupdate -expand -group External /tb_top/uut/HEX4
add wave -noupdate -expand -group External /tb_top/uut/HEX5
add wave -noupdate -expand -group Processor -radix hexadecimal /tb_top/uut/IC_0/ADDRESS
add wave -noupdate -expand -group Processor -radix hexadecimal /tb_top/uut/IC_0/DATA
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/CLOCK
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/INT
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/NMI
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/HALT
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/MREQ
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/IORQ
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/RD
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/WR
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/BUSAK
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/WAET
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/BUSRQ
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/RESET
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/MI
add wave -noupdate -expand -group Processor /tb_top/uut/IC_0/RFSH
add wave -noupdate -expand -group Processor -expand -group Registers -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(7)
add wave -noupdate -expand -group Processor -expand -group Registers -label TEMP -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(6)
add wave -noupdate -expand -group Processor -expand -group Registers -label PC -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(5)
add wave -noupdate -expand -group Processor -expand -group Registers -label SP -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(4)
add wave -noupdate -expand -group Processor -expand -group Registers -label HL -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(3)
add wave -noupdate -expand -group Processor -expand -group Registers -label DE -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(2)
add wave -noupdate -expand -group Processor -expand -group Registers -label BC -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(1)
add wave -noupdate -expand -group Processor -expand -group Registers -label AF -radix hexadecimal /tb_top/uut/IC_0/DEBUG_REGISTERS(0)
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_top/uut/IC_1/address
add wave -noupdate -expand -group Memory /tb_top/uut/IC_1/clock
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_top/uut/IC_1/data
add wave -noupdate -expand -group Memory /tb_top/uut/IC_1/wren
add wave -noupdate -expand -group Memory -radix hexadecimal /tb_top/uut/IC_1/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162771084 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {65625 ns}
