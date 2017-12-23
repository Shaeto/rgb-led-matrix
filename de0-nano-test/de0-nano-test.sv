module de0_nano_test_top (

	//////////// CLOCK //////////
	input				CLOCK_50,

	//////////// LED //////////
	output 	[7:0]	LED,

	//////////// KEY //////////
	input 	[1:0]	KEY,

	//////////// SW //////////
	input 	[3:0]	SW,

	//////////// SDRAM //////////
	output  [12:0]	DRAM_ADDR,
	output 	[1:0]	DRAM_BA,
	output 			DRAM_CAS_N,
	output 			DRAM_CKE,
	output 			DRAM_CLK,
	output 			DRAM_CS_N,
	inout   [15:0] DRAM_DQ,
	output 	[1:0] DRAM_DQM,
	output 			DRAM_RAS_N,
	output 			DRAM_WE_N,

	//////////// EPCS //////////
	output 			EPCS_ASDO,
	input 			EPCS_DATA0,
	output 			EPCS_DCLK,
	output 			EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	output 			G_SENSOR_CS_N,
	input 			G_SENSOR_INT,
	output 			I2C_SCLK,
	output 			I2C_SDAT,

	//////////// ADC //////////
	output 			ADC_CS_N,
	output 			ADC_SADDR,
	output 			ADC_SCLK,
	input 			ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	inout   [12:0] GPIO_2,
	input 	[2:0] GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout   [33:0] GPIO_0_D,
	input 	[1:0] GPIO_0_IN,

	//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
	inout   [33:0] GPIO_1_D,
	input 	[1:0] GPIO_1_IN
);

system c0(
		.clk_clk(CLOCK_50),                         //                      clk.clk
		.reset_reset_n(1'b1),                   //                    reset.reset_n
		.matrix_wire_led_r0(GPIO_0_D[0]),
		.matrix_wire_led_g0(GPIO_0_D[1]),
		.matrix_wire_led_b0(GPIO_0_D[2]),
		.matrix_wire_led_r1(GPIO_0_D[3]),
		.matrix_wire_led_g1(GPIO_0_D[4]),
		.matrix_wire_led_b1(GPIO_0_D[5]),
		.matrix_wire_led_clk(GPIO_0_D[6]),
		.matrix_wire_led_lat(GPIO_0_D[7]),
		.matrix_wire_led_oe(GPIO_0_D[8]),
		.matrix_wire_led_row(GPIO_0_D[12:9])
	);
	
endmodule
