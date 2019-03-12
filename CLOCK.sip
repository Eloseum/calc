set_global_assignment -entity "CLOCK" -library "lib_CLOCK" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "CLOCK" -library "lib_CLOCK" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "CLOCK" -library "lib_CLOCK" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_CLOCK" -name SPD_FILE [file join $::quartus(sip_path) "CLOCK.spd"]

set_global_assignment -library "lib_CLOCK" -name MISC_FILE [file join $::quartus(sip_path) "CLOCK_sim/CLOCK.vho"]
