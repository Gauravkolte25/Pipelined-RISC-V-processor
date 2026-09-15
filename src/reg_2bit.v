`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 12:26:41 PM
// Design Name: 
// Module Name: reg_2bit
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

module reg2b (
    input  wire [1:0] reg_in,
    input  wire       load,
    input  wire       clock,
    input  wire       clear,
    output reg  [1:0] reg_out
);

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 2'b00;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule