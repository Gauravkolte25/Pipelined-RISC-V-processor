`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 12:26:18 PM
// Design Name: 
// Module Name: reg_1bit
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


module reg1b (
    input  wire reg_in,
    input  wire load,
    input  wire clock,
    input  wire clear,
    output reg  reg_out
);

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 1'b0;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule