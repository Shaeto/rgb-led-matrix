module de0_nano_clock_top (

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

de0_nano_clock c0(
		.clk_clk(CLOCK_50),                         //                      clk.clk
		.reset_reset_n(1'b1),                   //                    reset.reset_n
		.altpll_sdram_clk(DRAM_CLK),                //             altpll_sdram.clk
		.altpll_areset_conduit_export(1'b0),    //    altpll_areset_conduit.export
		.key_wire_export(KEY),
		.led_wire_export(LED),
		
		.sdram_wire_addr(DRAM_ADDR),                 //               sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                   //                         .ba
		.sdram_wire_cas_n(DRAM_CAS_N),                //                         .cas_n
		.sdram_wire_cke(DRAM_CKE),                  //                         .cke
		.sdram_wire_cs_n(DRAM_CS_N),                 //                         .cs_n
		.sdram_wire_dq(DRAM_DQ),                   //                         .dq
		.sdram_wire_dqm(DRAM_DQM),                  //                         .dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                //                         .ras_n
		.sdram_wire_we_n(DRAM_WE_N),                 //                         .we_n
	
		.spi_wire_MISO(GPIO_2[2]),
		.spi_wire_MOSI(GPIO_2[3]),
		.spi_wire_SCLK(GPIO_2[4]),
		.spi_wire_SS_n(GPIO_2[5])
	);
	
endmodule
