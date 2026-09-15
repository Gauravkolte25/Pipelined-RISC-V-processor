`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:24:01 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter (
    input  wire        clear,
    input  wire        clock,
    input  wire        mux_sel,
    input  wire [31:0] address_in_0,
    input  wire [31:0] address_in_1,
    output wire [31:0] next_address,
    output wire [31:0] address_out
);

    wire [31:0] internal_address;

    // 2-to-1 Multiplexer select between address sources (e.g., PC+4 vs Jump/Branch)
    MUX_2_1 internal_mux (
        .selection(mux_sel),
        .input_0(address_in_0),
        .input_1(address_in_1),
        .output_0(internal_address)
    );

    // 32-bit Program Counter Register (enable hardcoded high to match VHDL '1')
    reg32b internal_register (
        .reg_in     (internal_address),
        .load    (1'b1),
        .clock   (clock),
        .clear   (clear),
        .reg_out     (address_out)
    );

    // Next address output for registered memory setups
    assign next_address = internal_address;

endmodule
