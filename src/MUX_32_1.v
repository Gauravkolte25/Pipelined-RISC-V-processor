`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 12:10:39 PM
// Design Name: 
// Module Name: MUX_32_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_32_1 (
    input  wire [4:0]  selection,
    input  wire [31:0] input_0,  input_1,  input_2,  input_3,
    input  wire [31:0] input_4,  input_5,  input_6,  input_7,
    input  wire [31:0] input_8,  input_9,  input_10, input_11,
    input  wire [31:0] input_12, input_13, input_14, input_15,
    input  wire [31:0] input_16, input_17, input_18, input_19,
    input  wire [31:0] input_20, input_21, input_22, input_23,
    input  wire [31:0] input_24, input_25, input_26, input_27,
    input  wire [31:0] input_28, input_29, input_30, input_31,
    output reg  [31:0] output_0
);

    always @(*) begin
        case (selection)
            5'd0:  output_0 = input_0;
            5'd1:  output_0 = input_1;
            5'd2:  output_0 = input_2;
            5'd3:  output_0 = input_3;
            5'd4:  output_0 = input_4;
            5'd5:  output_0 = input_5;
            5'd6:  output_0 = input_6;
            5'd7:  output_0 = input_7;
            5'd8:  output_0 = input_8;
            5'd9:  output_0 = input_9;
            5'd10: output_0 = input_10;
            5'd11: output_0 = input_11;
            5'd12: output_0 = input_12;
            5'd13: output_0 = input_13;
            5'd14: output_0 = input_14;
            5'd15: output_0 = input_15;
            5'd16: output_0 = input_16;
            5'd17: output_0 = input_17;
            5'd18: output_0 = input_18;
            5'd19: output_0 = input_19;
            5'd20: output_0 = input_20;
            5'd21: output_0 = input_21;
            5'd22: output_0 = input_22;
            5'd23: output_0 = input_23;
            5'd24: output_0 = input_24;
            5'd25: output_0 = input_25;
            5'd26: output_0 = input_26;
            5'd27: output_0 = input_27;
            5'd28: output_0 = input_28;
            5'd29: output_0 = input_29;
            5'd30: output_0 = input_30;
            5'd31: output_0 = input_31;
            default: output_0 = 32'h00000000;
        endcase
    end

endmodule