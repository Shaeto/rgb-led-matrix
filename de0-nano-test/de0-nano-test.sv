module de0_nano_test_top (

	//////////// CLOCK //////////
	input				CLOCK_50,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	output         LED_R0,
	output         LED_G0,
	output         LED_B0,
	output         LED_R1,
	output         LED_G1,
	output         LED_B1,
	output         LED_CLK,
	output         LED_LAT,
	output         LED_OE,
	output  [3:0]  LED_ROW
);

system c0(
		.clk_clk(CLOCK_50),                     //                    clk.clk
		.reset_reset_n(1'b1),                   //                    reset.reset_n
		.matrix_wire_led_r0(LED_R0),
		.matrix_wire_led_g0(LED_G0),
		.matrix_wire_led_b0(LED_B0),
		.matrix_wire_led_r1(LED_R1),
		.matrix_wire_led_g1(LED_G1),
		.matrix_wire_led_b1(LED_B1),
		.matrix_wire_led_clk(LED_CLK),
		.matrix_wire_led_lat(LED_LAT),
		.matrix_wire_led_oe(LED_OE),
		.matrix_wire_led_row(LED_ROW[3:0])
	);
	
endmodule
