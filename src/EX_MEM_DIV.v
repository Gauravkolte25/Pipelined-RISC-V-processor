`timescale 1ns / 1ps

module EX_MEM_DIV (
    // INPUTS
    input  wire        clock,
    input  wire        clear,

    // MEM control signals
    input  wire [2:0]  data_format_in,
    input  wire        datamem_write_in,
    input  wire        jump_flag_in,

    // WB control signals
    input  wire [1:0]  mux0_sel_in,
    input  wire        reg_file_write_in,
    input  wire [4:0]  reg_file_write_address_in,

    // Data inputs
    input  wire [31:0] ALU_output_in,
    input  wire [31:0] register_file_output_1_in,
    input  wire        ALU_branch_response_in,
    input  wire [31:0] instruction_address_in,

    // OUTPUTS

    // MEM control signals
    output wire [2:0]  data_format_out,
    output wire        datamem_write_out,
    output wire        jump_flag_out,

    // WB control signals
    output wire [1:0]  mux0_sel_out,
    output wire        reg_file_write_out,
    output wire [4:0]  reg_file_write_address_out,

    // Data outputs
    output wire [31:0] ALU_output_out,
    output wire [31:0] register_file_output_1_out,
    output wire        ALU_branch_response_out,
    output wire [31:0] instruction_address_out
);

    // Constant enable signal ('1')
    wire enable = 1'b1;

    //-------------------------------------------------------------------------
    // MEM Control Registers
    //-------------------------------------------------------------------------
    reg3b data_format_reg (
        .reg_in  (data_format_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (data_format_out)
    );

    reg1b datamem_write_reg (
        .reg_in  (datamem_write_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (datamem_write_out)
    );

    reg1b jump_flag_reg (
        .reg_in  (jump_flag_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (jump_flag_out)
    );

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

    reg32b register_file_output_1_reg (
        .reg_in  (register_file_output_1_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (register_file_output_1_out)
    );

    reg1b ALU_branch_response_reg (
        .reg_in  (ALU_branch_response_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (ALU_branch_response_out)
    );

    reg32b instruction_address_reg (
        .reg_in  (instruction_address_in),
        .load    (enable),
        .clock   (clock),
        .clear   (clear),
        .reg_out (instruction_address_out)
    );

endmodule