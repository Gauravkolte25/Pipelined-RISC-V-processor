`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 12:23:00 PM
// Design Name: 
// Module Name: MUX_5_1
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

module mux_5_1 (
    input  wire [2:0]  selection,
    input  wire [31:0] input_0,
    input  wire [31:0] input_1,
    input  wire [31:0] input_2,
    input  wire [31:0] input_3,
    input  wire [31:0] input_4,
    output reg  [31:0] output_0
);

    always @(*) begin
        case (selection)
            3'b000:  output_0 = input_0;
            3'b001:  output_0 = input_1;
            3'b010:  output_0 = input_2;
            3'b011:  output_0 = input_3;
            3'b100:  output_0 = input_4;
            default: output_0 = 32'h00000000;
        endcase
    end

endmodule