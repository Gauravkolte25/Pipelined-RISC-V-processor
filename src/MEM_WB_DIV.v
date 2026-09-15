`timescale 1ns / 1ps

module MEM_WB_DIV (
    // INPUTS
    input  wire        clock,
    input  wire        clear,

    // WB control signals
    input  wire [1:0]  mux0_sel_in,
    input  wire        reg_file_write_in,
    input  wire [4:0]  reg_file_write_address_in,

    // Data inputs
    input  wire [31:0] ALU_output_in,
    input  wire [31:0] datamem_output_in,
    input  wire [31:0] instruction_address_in,

    // OUTPUTS

    // WB control signals
    output wire [1:0]  mux0_sel_out,
    output wire        reg_file_write_out,
    output wire [4:0]  reg_file_write_address_out,

    // Data outputs
    output wire [31:0] ALU_output_out,
    output wire [31:0] datamem_output_out,
    output wire [31:0] instruction_address_out
);

    // Constant enable signal ('1')
    wire enable = 1'b1;

    //-------------------------------------------------------------------------
    // WB Control Registers
    //-------------------------------------------------------------------------
    reg2b mux0_sel_reg (
        .reg_in  (mux0_sel_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (mux0_sel_out)
    );

    reg1b reg_file_write_reg (
        .reg_in  (reg_file_write_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (reg_file_write_out)
    );

    reg5b reg_file_write_address_reg (
        .reg_in  (reg_file_write_address_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (reg_file_write_address_out)
    );

    //-------------------------------------------------------------------------
    // Data Registers
    //-------------------------------------------------------------------------
    reg32b ALU_output_reg (
        .reg_in  (ALU_output_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (ALU_output_out)
    );

    reg32b datamem_output_reg (
        .reg_in  (datamem_output_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (datamem_output_out)
    );

    reg32b instruction_address_reg (
        .reg_in  (instruction_address_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (instruction_address_out)
    );

endmodule