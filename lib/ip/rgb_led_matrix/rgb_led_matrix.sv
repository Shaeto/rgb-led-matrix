// rgb_led_matrix.sv
// synthesis VERILOG_INPUT_VERSION SYSTEMVERILOG_2005

`timescale 1 ps / 1 ps
module rgb_led_matrix #(
           parameter       matrix_width      = 64,
           parameter       matrix_height     = 32,
           parameter       num_of_matrices   = 1,
           parameter       RAM_ADDRESS_WIDTH = 14,
           parameter       INPUT_CLK_FRQ     = 50000000,
           parameter[31:0] start_addr        = 32'b00000000000000000000000000000000
       ) (
           input  wire        						clk,
           input  wire        						reset_n,
           output logic       						master_read,
           input  wire [63:0] 						master_readdata,
           output wire [7:0]  						master_byteenable,
           output wire [RAM_ADDRESS_WIDTH-1:0]  master_address,
           input  wire        						master_readdatavalid,
           input  wire        						master_waitrequest,
           output reg         						led_clk,
           output reg         						led_lat,
           output reg         						led_oe,
           output wire  [3:0] 						led_row,
           output wire        						led_r0,
           output wire        						led_g0,
           output wire        						led_b0,
           output wire        						led_r1,
           output wire        						led_g1,
           output wire        						led_b1
       );

reg [RAM_ADDRESS_WIDTH-1:0] r_ram_address;
assign master_address = r_ram_address;

assign master_byteenable = 8'b11101110;

reg [3:0] r_led_row;
assign led_row = r_led_row;

reg r_led_r0, r_led_g0, r_led_b0, r_led_r1, r_led_g1, r_led_b1;

assign led_r0 = r_led_r0;
assign led_g0 = r_led_g0;
assign led_b0 = r_led_b0;
assign led_r1 = r_led_r1;
assign led_g1 = r_led_g1;
assign led_b1 = r_led_b1;

localparam MATRIX_COLOR_DEPTH = 256;
localparam MATRIX_FRAME_RATE = 25;
localparam MATRIX_PWM_RATE = MATRIX_COLOR_DEPTH * MATRIX_FRAME_RATE;
localparam MATRIX_UPDATE_CLK = (INPUT_CLK_FRQ / MATRIX_PWM_RATE) - 1;

reg [$clog2(MATRIX_COLOR_DEPTH)-1:0] color_frame = 0;
reg [$clog2(MATRIX_PWM_RATE)-1:0] pwm_frame = 0;
reg [$clog2(MATRIX_PWM_RATE)-1:0] cur_frame = 0;
reg [$clog2(MATRIX_UPDATE_CLK)-1:0] clk_counter = 0;
reg [$clog2(matrix_width*num_of_matrices):0] col_number;
reg [$clog2(matrix_height/2):0] row_number;

reg render_en = 0;

typedef enum { matrix_off, matrix_idle, matrix_req_data, matrix_push_data, matrix_latch_data } matrix_state_t;
matrix_state_t matrix_state = matrix_idle;

`include "rgb_matrix_lut.sv"

always @(posedge clk or negedge reset_n)
begin
    if (!reset_n)
    begin
        color_frame <= 0;
        pwm_frame <= 0;
        clk_counter <= 0;
        render_en <= 0;
    end
    else
    begin
        if (clk_counter <= MATRIX_UPDATE_CLK)
        begin
            clk_counter <= clk_counter + 1'b1;
            render_en <= 0;
        end
        else
        begin
            clk_counter <= 0;

            if (color_frame < MATRIX_COLOR_DEPTH)
            begin
                color_frame <= color_frame + 1'b1;
            end
            else
            begin
                color_frame <= 0;
            end

            if (pwm_frame < MATRIX_PWM_RATE)
            begin
                pwm_frame <= pwm_frame + 1'b1;
            end
            else
            begin
                pwm_frame <= 0;
            end

            render_en <= 1;
        end
    end
end

always @(posedge clk or negedge reset_n)
begin
    // matrix default control signal states
    if (!reset_n)
    begin
        cur_frame <= 0;
        col_number <= 0;
        row_number <= 0;

        r_led_row <= 4'b1111;

        r_ram_address <= 0;
        master_read <= 1'b0;

        led_lat <= 1'b0;
        led_oe <= 1'b1;
        led_clk <= 1'b0;

        matrix_state <= matrix_idle;
    end
    else
    begin
        led_oe <= 1'b0;
        led_clk <= 1'b0;
        led_lat <= 1'b0;

        if (cur_frame != pwm_frame)
        begin
            cur_frame <= pwm_frame;
            r_ram_address <= 0;
            row_number <= 0;
            matrix_state <= matrix_req_data;
        end
        case (matrix_state)
            matrix_off:
            begin
                led_oe <= 1'b0;
                master_read <= 1'b0;
            end
            matrix_idle:
            begin
                // keep it idling
                master_read <= 1'b0;
            end
            matrix_req_data:
            begin
                master_read <= 1'b1;
                matrix_state <= matrix_push_data;
            end
            matrix_push_data:
            begin
                master_read <= 1'b0;
                r_led_r0 <= pwm_lut[master_readdata[63:56]][color_frame];
                r_led_g0 <= pwm_lut[master_readdata[55:48]][color_frame];
                r_led_b0 <= pwm_lut[master_readdata[47:40]][color_frame];

                r_led_r1 <= pwm_lut[master_readdata[31:24]][color_frame];
                r_led_g1 <= pwm_lut[master_readdata[23:16]][color_frame];
                r_led_b1 <= pwm_lut[master_readdata[15:8]][color_frame];

                led_clk <= 1'b1;

                r_ram_address <= r_ram_address + 4'b1000;

                col_number <= col_number + 1'b1;

                if (col_number == (num_of_matrices * matrix_width))
                begin
                    matrix_state <= matrix_latch_data;
                end
                else
                begin
                    matrix_state <= matrix_req_data;
                end
            end
            matrix_latch_data:
            begin
                master_read <= 1'b0;
                row_number <= row_number + 1'b1;
                r_led_row <= row_number;
                led_oe <= 1'b1;
                led_lat <= 1'b1;
                if (row_number == (matrix_height / 2))
                begin
                    matrix_state <= matrix_idle;
                end
                else
                begin
                    matrix_state <= matrix_req_data;
                end
            end
        endcase
    end
end
endmodule
