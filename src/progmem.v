`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 12:34:40 PM
// Design Name: 
// Module Name: progmem
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

module progmem (
    input wire clock,
    input  wire [15:0] address,
    output wire [31:0] output_data
);

    reg [31:0] memory [0:255];
    integer i;

    initial begin
    // Initialize memory with NOPs
    for (i = 0; i < 256; i = i + 1) memory[i] = 32'h00000013;

    // Test Sequence: Branch Taken & Pipeline Flush
memory[0] = 32'h00500093; // 0x00: addi x1, x0, 5
memory[1] = 32'h00500113; // 0x04: addi x2, x0, 5
memory[2] = 32'h00208a63; // 0x08: beq  x1, x2, 20 (Target = 0x08 + 20 = 0x1C)
memory[3] = 32'h00100f13; // 0x0C: addi x30, x0, 1
memory[4] = 32'h00200f93; // 0x10: addi x31, x0, 2
memory[7] = 32'h00100f13; // 0x1C: addi x30, x0, 1
memory[8] = 32'h00a00f93; //  addi x31, x0, 10 (Target)
memory[9] = 32'h00000013; //  NOP
end

    // Word-indexed lookup
    assign output_data = memory[address];

endmodule 
