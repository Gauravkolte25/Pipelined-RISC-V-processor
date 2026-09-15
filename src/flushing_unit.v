`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:57:25 PM
// Design Name: 
// Module Name: flushing_unit
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


module flushing_unit (
    input  wire clear,
    input  wire clock,
    input  wire flushing_control,
    output reg  flushing_output
);

    // Synchronous state register with asynchronous reset (clear)
    always @(posedge clock or posedge clear) begin
        if (clear) begin
            flushing_output <= 1'b0;
        end else begin
            flushing_output <= flushing_control;
        end
    end

endmodule
