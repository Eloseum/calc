set_global_assignment -entity "TestClock" -library "lib_TestClock" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "TestClock" -library "lib_TestClock" -name IP_TOOL_VERSION "18.0"
set_global_assignment -entity "TestClock" -library "lib_TestClock" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_TestClock" -name SPD_FILE [file join $::quartus(sip_path) "TestClock.spd"]

set_global_assignment -library "lib_TestClock" -name MISC_FILE [file join $::quartus(sip_path) "TestClock_sim/TestClock.vho"]
