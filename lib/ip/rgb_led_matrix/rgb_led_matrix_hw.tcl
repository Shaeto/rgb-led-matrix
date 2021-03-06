# TCL File Generated by Component Editor 17.1
# Sun Dec 31 22:28:54 MSK 2017
# DO NOT MODIFY


# 
# rgb_led_matrix "RGB LED Matrix Driver" v1.0
# Evgeny Sabelskiy 2017.12.31.22:28:54
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module rgb_led_matrix
# 
set_module_property DESCRIPTION ""
set_module_property NAME rgb_led_matrix
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Evgeny Sabelskiy"
set_module_property DISPLAY_NAME "RGB LED Matrix Driver"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL rgb_led_matrix
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file rgb_led_matrix.sv SYSTEM_VERILOG PATH rgb_led_matrix.sv TOP_LEVEL_FILE
add_fileset_file rgb_matrix_lut.sv SYSTEM_VERILOG_INCLUDE PATH rgb_matrix_lut.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL rgb_led_matrix
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file rgb_led_matrix.sv SYSTEM_VERILOG PATH rgb_led_matrix.sv
add_fileset_file rgb_matrix_lut.sv SYSTEM_VERILOG_INCLUDE PATH rgb_matrix_lut.sv


# 
# parameters
# 
add_parameter MATRIX_WIDTH INTEGER 64 "Matrix Width"
set_parameter_property MATRIX_WIDTH DEFAULT_VALUE 64
set_parameter_property MATRIX_WIDTH DISPLAY_NAME MATRIX_WIDTH
set_parameter_property MATRIX_WIDTH WIDTH ""
set_parameter_property MATRIX_WIDTH TYPE INTEGER
set_parameter_property MATRIX_WIDTH UNITS None
set_parameter_property MATRIX_WIDTH ALLOWED_RANGES {16 32 64}
set_parameter_property MATRIX_WIDTH DESCRIPTION "Matrix Width"
set_parameter_property MATRIX_WIDTH HDL_PARAMETER true
add_parameter MATRIX_HEIGHT INTEGER 32 "Matrix Height"
set_parameter_property MATRIX_HEIGHT DEFAULT_VALUE 32
set_parameter_property MATRIX_HEIGHT DISPLAY_NAME MATRIX_HEIGHT
set_parameter_property MATRIX_HEIGHT TYPE INTEGER
set_parameter_property MATRIX_HEIGHT UNITS None
set_parameter_property MATRIX_HEIGHT ALLOWED_RANGES {16 32}
set_parameter_property MATRIX_HEIGHT DESCRIPTION "Matrix Height"
set_parameter_property MATRIX_HEIGHT HDL_PARAMETER true
add_parameter NUM_OF_MATRICES INTEGER 1 "Number of connected matrices"
set_parameter_property NUM_OF_MATRICES DEFAULT_VALUE 1
set_parameter_property NUM_OF_MATRICES DISPLAY_NAME NUM_OF_MATRICES
set_parameter_property NUM_OF_MATRICES WIDTH ""
set_parameter_property NUM_OF_MATRICES TYPE INTEGER
set_parameter_property NUM_OF_MATRICES UNITS None
set_parameter_property NUM_OF_MATRICES ALLOWED_RANGES {1 2 3 4}
set_parameter_property NUM_OF_MATRICES DESCRIPTION "Number of connected matrices"
set_parameter_property NUM_OF_MATRICES HDL_PARAMETER true
add_parameter RAM_ADDRESS_WIDTH INTEGER 14
set_parameter_property RAM_ADDRESS_WIDTH DEFAULT_VALUE 14
set_parameter_property RAM_ADDRESS_WIDTH DISPLAY_NAME RAM_ADDRESS_WIDTH
set_parameter_property RAM_ADDRESS_WIDTH TYPE INTEGER
set_parameter_property RAM_ADDRESS_WIDTH UNITS None
set_parameter_property RAM_ADDRESS_WIDTH HDL_PARAMETER true
add_parameter INPUT_CLK_FRQ INTEGER 50000000 "Frequency of input clock signal"
set_parameter_property INPUT_CLK_FRQ DEFAULT_VALUE 50000000
set_parameter_property INPUT_CLK_FRQ DISPLAY_NAME INPUT_CLK_FRQ
set_parameter_property INPUT_CLK_FRQ WIDTH ""
set_parameter_property INPUT_CLK_FRQ TYPE INTEGER
set_parameter_property INPUT_CLK_FRQ UNITS Hertz
set_parameter_property INPUT_CLK_FRQ ALLOWED_RANGES 10000000:60000000
set_parameter_property INPUT_CLK_FRQ DESCRIPTION "Frequency of input clock signal"
set_parameter_property INPUT_CLK_FRQ HDL_PARAMETER true


# 
# display items
# 
add_display_item "" Matrix GROUP ""
add_display_item "" Chaining GROUP ""
add_display_item "" Clock GROUP ""
add_display_item Matrix MATRIX_WIDTH PARAMETER ""
add_display_item Matrix MATRIX_HEIGHT PARAMETER ""
add_display_item Chaining NUM_OF_MATRICES PARAMETER ""
add_display_item Clock INPUT_CLK_FRQ PARAMETER ""
add_display_item Buffer RAM_ADDRESS_WIDTH PARAMETER ""


# 
# connection point matrix_wire
# 
add_interface matrix_wire conduit end
set_interface_property matrix_wire associatedClock clk
set_interface_property matrix_wire associatedReset reset
set_interface_property matrix_wire ENABLED true
set_interface_property matrix_wire EXPORT_OF ""
set_interface_property matrix_wire PORT_NAME_MAP ""
set_interface_property matrix_wire CMSIS_SVD_VARIABLES ""
set_interface_property matrix_wire SVD_ADDRESS_GROUP ""

add_interface_port matrix_wire led_r0 led_r0 Output 1
add_interface_port matrix_wire led_g0 led_g0 Output 1
add_interface_port matrix_wire led_b0 led_b0 Output 1
add_interface_port matrix_wire led_r1 led_r1 Output 1
add_interface_port matrix_wire led_g1 led_g1 Output 1
add_interface_port matrix_wire led_b1 led_b1 Output 1
add_interface_port matrix_wire led_clk led_clk Output 1
add_interface_port matrix_wire led_lat led_lat Output 1
add_interface_port matrix_wire led_oe led_oe Output 1
add_interface_port matrix_wire led_row led_row Output 4


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point master
# 
add_interface master avalon start
set_interface_property master addressUnits SYMBOLS
set_interface_property master associatedClock clk
set_interface_property master associatedReset reset
set_interface_property master bitsPerSymbol 8
set_interface_property master burstOnBurstBoundariesOnly false
set_interface_property master burstcountUnits WORDS
set_interface_property master doStreamReads false
set_interface_property master doStreamWrites false
set_interface_property master holdTime 0
set_interface_property master linewrapBursts false
set_interface_property master maximumPendingReadTransactions 0
set_interface_property master maximumPendingWriteTransactions 0
set_interface_property master readLatency 0
set_interface_property master readWaitTime 1
set_interface_property master setupTime 0
set_interface_property master timingUnits Cycles
set_interface_property master writeWaitTime 0
set_interface_property master ENABLED true
set_interface_property master EXPORT_OF ""
set_interface_property master PORT_NAME_MAP ""
set_interface_property master CMSIS_SVD_VARIABLES ""
set_interface_property master SVD_ADDRESS_GROUP ""

add_interface_port master master_read read Output 1
add_interface_port master master_readdata readdata Input 64
add_interface_port master master_byteenable byteenable Output 8
add_interface_port master master_address address Output RAM_ADDRESS_WIDTH
add_interface_port master master_readdatavalid readdatavalid Input 1
add_interface_port master master_waitrequest waitrequest Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1

proc elaborate {} {
}
