`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 11:06:30 AM
// Design Name: 
// Module Name: MUX_2_1
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


module MUX_2_1(
input wire selection, 
input wire [31:0] input_0,
input wire [31:0] input_1,
output wire [31:0] output_0
    );
    
    assign output_0 = (selection)? input_1:input_0;
endmodule
