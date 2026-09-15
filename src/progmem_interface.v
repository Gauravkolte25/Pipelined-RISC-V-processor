`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 12:39:19 PM
// Design Name: 
// Module Name: progmem_interface
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


`timescale 1ns / 1ps

module progmem_interface (
    input  wire        clock,
    input  wire [31:0] byte_address,
    output wire [31:0] output_data
);

    wire [31:0] memory_address;

    // Convert byte address to word address (divide by 4)
    assign memory_address = byte_address >> 2;

    // Program Memory Sub-module Instantiation
    progmem progmem_0 (
        .address(memory_address[15:0]),
        .clock(clock),
        .output_data(output_data)
    );

endmodule