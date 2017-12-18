// rgb_led_matrix.sv
// synthesis VERILOG_INPUT_VERSION SYSTEMVERILOG_2005

`timescale 1 ps / 1 ps
module rgb_led_matrix #(
		parameter       matrix_width     = 64,
		parameter       matrix_height    = 32,
		parameter       number_of_matrix = 1,
		parameter       color_depth      = 256,
		parameter[31:0] start_addr       = 32'b00000000000000000000000000000000
	) (
		input  wire        clk,
		input  wire        reset,
		output wire        ram1_read,
		input  wire [31:0] ram1_readdata,
		output wire [3:0]  ram1_byteenable,
		output wire [12:0] ram1_address,
		input  wire        ram1_readdatavalid,
		input  wire        ram1_waitrequest,
		output wire        ram2_read,
		input  wire [31:0] ram2_readdata,
		output wire [3:0]  ram2_byteenable,
		output wire [12:0] ram2_address,
		input  wire        ram2_readdatavalid,
		input  wire        ram2_waitrequest,
		output reg         led_clk,
		output reg         led_lat,
		output reg         led_oe,
		output wire  [3:0] led_row,
		output wire        led_r0,
		output wire        led_g0,
		output wire        led_b0,
		output wire        led_r1,
		output wire        led_g1,
		output wire        led_b1
	);

	reg [12:0] r_ram1_address, r_ram2_address;

	assign ram1_address = r_ram1_address;
	assign ram2_address = r_ram2_address;

//	reg [3:0] r_ram1_byteenable = 4'b0111, r_ram2_byteenable = 4'b0111;

//	assign ram1_byteenable = r_ram1_byteenable;
//	assign ram2_byteenable = r_ram2_byteenable;
	assign ram1_byteenable = 4'b1110;
	assign ram2_byteenable = 4'b1110;

	reg [3:0] r_led_row;
	assign led_row = r_led_row;

	reg r_led_r0, r_led_g0, r_led_b0, r_led_r1, r_led_g1, r_led_b1;

	assign led_r0 = r_led_r0;
	assign led_g0 = r_led_g0;
	assign led_b0 = r_led_b0;
	assign led_r1 = r_led_r1;
	assign led_g1 = r_led_g1;
	assign led_b1 = r_led_b1;

	reg r_ram1_read = 0, r_ram2_read = 0;
	assign ram1_read = r_ram1_read, ram2_read = r_ram2_read;

	// matrix update rate per second
	localparam CLK_SPEED = 50000000;
	localparam MATRIX_PWM_RATE = 256;
	localparam MATRIX_UPDATE_RATE = 30;
	localparam MATRIX_CLK_MAX = (CLK_SPEED / MATRIX_UPDATE_RATE) - 1;

	reg [$clog2(MATRIX_PWM_RATE)-1:0] frame_number = 0;
	reg [$clog2(MATRIX_CLK_MAX)-1:0] clk_counter = 0;
	reg [7:0] col_number;
	reg [3:0] row_number;

	reg render_en;

	typedef enum { matrix_idle, matrix_begin_frame, matrix_begin_row, matrix_req_data, /*matrix_get_data, */ matrix_push_data, matrix_latch_data, matrix_end_row, matrix_end_frame } matrix_state_t;
        matrix_state_t matrix_state = matrix_idle;

	reg [255:0] r_lut [0:255];

	initial begin
	  `include "matrix_lut.v"
	end

	always @(posedge clk or posedge reset) begin
		if (reset == 1)
		begin
		  clk_counter <= 0;
		  render_en <= 0;
		end else
		begin
		  if (clk_counter <= MATRIX_CLK_MAX)
		  begin
		    clk_counter <= clk_counter + 1'b1;
		    render_en <= 0;
		  end
		  else
		  begin
                    clk_counter <= 0;
		    render_en <= 1;
		  end
		end
	end

	always @(posedge clk or posedge reset) begin
	    // matrix default control signal states
	    if (reset) begin
	      frame_number <= 8'b0;
	      col_number <= 6'b0;
	      row_number <= 4'b0000;

              r_led_row <= 4'b0000;

              r_ram1_address <= 13'b0;
              r_ram2_address <= 13'b0;

              r_ram1_read <= 1'b0;
              r_ram2_read <= 1'b0;

              led_lat <= 1'b0;
              led_oe <= 1'b1;
              led_clk <= 1'b0;

	      matrix_state <= matrix_idle;
	    end else
	    begin
	      led_oe <= 1'b0;
	      led_clk <= 1'b0;
	      led_lat <= 1'b0;

//	      if (render_en) begin
//	        if (matrix_state == matrix_idle) begin
//                matrix_state = matrix_begin_frame;
//	        end
//	      end
	        case (matrix_state)
	          matrix_idle: begin
                    matrix_state = matrix_begin_frame;
	          end
	          matrix_begin_frame: begin
                    r_ram1_address <= 13'b0;
                    r_ram2_address <= 13'b0;
                    row_number <= 4'b1111;

                    matrix_state <= matrix_begin_row;
	          end
	          matrix_begin_row: begin
	            col_number <= 6'b0;
	            row_number <= row_number + 1'b1;

                    matrix_state <= matrix_req_data;
		  end
	          matrix_req_data: begin
                      r_ram1_read <= 1'b1;
                      r_ram2_read <= 1'b1;

                      matrix_state <= matrix_push_data;
	          end
/*
                      matrix_state <= matrix_get_data;
	          end
                  matrix_get_data: begin
                      r_ram1_read <= 1'b0;
                      r_ram2_read <= 1'b0;

                      matrix_state <= matrix_push_data;
                  end
*/
	          matrix_push_data: begin
                      r_ram1_read <= 1'b0;
                      r_ram2_read <= 1'b0;

//	              if (ram1_readdatavalid && ram2_readdatavalid) begin
	              r_led_r0 <= r_lut[ram1_readdata[31:24]][frame_number];
	              r_led_g0 <= r_lut[ram1_readdata[23:16]][frame_number];
	              r_led_b0 <= r_lut[ram1_readdata[15:8]][frame_number];

	              r_led_r1 <= r_lut[ram2_readdata[31:24]][frame_number];
	              r_led_g1 <= r_lut[ram2_readdata[23:16]][frame_number];
	              r_led_b1 <= r_lut[ram2_readdata[15:8]][frame_number];

                      led_clk <= 1'b1;

                      r_ram1_address <= r_ram1_address + 3'b100;
                      r_ram2_address <= r_ram2_address + 3'b100;

                      col_number <= col_number + 1'b1;

                      if (col_number == (number_of_matrix * matrix_width - 1)) begin
                        matrix_state <= matrix_latch_data;
                      end else
                      begin
                        matrix_state <= matrix_req_data;
                      end
/*
                    end else
                    begin
                        matrix_state <= matrix_push_data;
                    end
*/
	          end
                  matrix_latch_data: begin
                    r_led_row <= row_number;
	    	    led_oe <= 1'b1;
	            led_lat <= 1'b1;
                    matrix_state <= matrix_end_row;
                  end
	          matrix_end_row: begin
	    	    led_oe <= 1'b1;
                    col_number <= 6'b0;
                    if (row_number == ((matrix_height/2)-1)) begin
                      matrix_state <= matrix_end_frame;
                    end else
                    begin
                      matrix_state <= matrix_begin_row;
                    end
	          end
	          matrix_end_frame: begin
	            if (frame_number == (MATRIX_PWM_RATE - 1)) begin
                      frame_number <= 0;
                      matrix_state <= matrix_idle;
	            end
	              else
	              begin
                        frame_number <= frame_number + 1'b1;
                        matrix_state <= matrix_begin_frame;
                      end
	          end
	        endcase
            end
	end
endmodule
