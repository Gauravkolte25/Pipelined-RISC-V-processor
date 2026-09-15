`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:24:01 PM
// Design Name: 
// Module Name: jump_target_unit
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


module jump_target_unit (
    input  wire        JTU_mux_sel,
    input  wire [31:0] instruction_address_ID_EX,
    input  wire [31:0] register_file_output_0,
    input  wire [31:0] immediate,
    output wire [31:0] JTU_output
);

    wire [31:0] mux_output;

    // Structural sub-module instantiations matching your VHDL structure:
    MUX_2_1 internal_mux (
        .selection(JTU_mux_sel),
        .input_0(instruction_address_ID_EX),
        .input_1(register_file_output_0),
        .output_0(mux_output)
    );

    adder internal_adder (
        .input_0(mux_output),
        .input_1(immediate),
        .output_0(JTU_output)
    );

endmodule
