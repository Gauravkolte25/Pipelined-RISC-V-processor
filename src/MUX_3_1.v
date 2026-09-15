`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 11:09:29 AM
// Design Name: 
// Module Name: MUX_3_1
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


module MUX_3_1(
    input wire [1:0] selection,
    input  wire [31:0] input_0,
    input  wire [31:0] input_1,
    input  wire [31:0] input_2,
    output wire [31:0] output_0
);

    assign output_0 = (selection == 2'b00) ? input_0 :
                      (selection == 2'b01) ? input_1 :
                      (selection == 2'b10) ? input_2 : 32'h00000000;
endmodule
