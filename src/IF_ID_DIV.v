`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 03:01:03 PM
// Design Name: 
// Module Name: IF_ID_DIV
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


module IF_ID_DIV (
    // INPUTS
    input  wire        clock,
    input  wire        clear,

    // Data Inputs
    input  wire [31:0] instruction_address_in,
    input  wire [31:0] instruction_data_in,

    // OUTPUTS
    // Data Outputs
    output wire [31:0] instruction_address_out,
    output wire [31:0] instruction_data_out
);

    // Constant enable/load signal ('1')
    wire enable = 1'b1;

    // Register Instantiations matched to reg32b port names
    reg32b instruction_address_reg (
        .reg_in  (instruction_address_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (instruction_address_out)
    );

    reg32b instruction_data_reg (
        .reg_in  (instruction_data_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (instruction_data_out)
    );

endmodule