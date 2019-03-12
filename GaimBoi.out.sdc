## Generated SDC file "GaimBoi.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"

## DATE    "Tue Mar 12 08:19:25 2019"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 1.000 -waveform { 0.000 0.500 } [get_ports {altera_reserved_tck}]
create_clock -name {CLOCK_50} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLOCK_50}]
create_clock -name {Processor:IC_0|MI} -period 1.000 -waveform { 0.000 0.500 } [get_registers {Processor:IC_0|MI}]
create_clock -name {Processor:IC_0|MREQ} -period 1.000 -waveform { 0.000 0.500 } [get_registers {Processor:IC_0|MREQ}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|cascadeout} -source [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 100 -master_clock {IC_4|clock_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]} [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|cascadeout}] 
create_generated_clock -name {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[1].output_counter|divclk} -source [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[1].output_counter|cascadein}] -duty_cycle 50/1 -multiply_by 1 -divide_by 12 -master_clock {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|cascadeout} [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|counter[1].output_counter|divclk}] 
create_generated_clock -name {IC_4|clock_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]} -source [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|refclkin}] -duty_cycle 50/1 -multiply_by 12 -divide_by 2 -master_clock {CLOCK_50} [get_pins {IC_4|clock_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

