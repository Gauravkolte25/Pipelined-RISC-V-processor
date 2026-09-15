`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 12:29:45 PM
// Design Name: 
// Module Name: reg_3bit
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


module reg3b (
    input  wire [2:0] reg_in,
    input  wire       load,
    input  wire       clock,
    input  wire       clear,
    output reg  [2:0] reg_out
);

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 3'b000;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule