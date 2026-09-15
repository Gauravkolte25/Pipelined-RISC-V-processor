`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 03:01:03 PM
// Design Name: 
// Module Name: ID_EX_DIV
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
module ID_EX_DIV (
    // INPUTS
    input  wire        clock,
    input  wire        clear,

    // EX control signals
    input  wire [3:0]  ALU_operation_in,
    input  wire        ALU_branch_in,
    input  wire [2:0]  ALU_branch_control_in,
    input  wire        mux1_sel_in,
    input  wire        JTU_mux_sel_in,

    // MEM control signals
    input  wire [2:0]  data_format_in,
    input  wire        datamem_write_in,
    input  wire        jump_flag_in,

    // WB control signals
    input  wire [1:0]  mux0_sel_in,
    input  wire        reg_file_write_in,
    input  wire [4:0]  reg_file_write_address_in,

    // Read addresses to be given to the forwarding unit
    input  wire [4:0]  register_file_read_address_0_in,
    input  wire [4:0]  register_file_read_address_1_in,

    // Data
    input  wire [31:0] register_file_output_0_in,
    input  wire [31:0] register_file_output_1_in,
    input  wire [31:0] immediate_in,
    input  wire [31:0] instruction_address_in,

    // OUTPUTS

    // EX control signals
    output wire [3:0]  ALU_operation_out,
    output wire        ALU_branch_out,
    output wire [2:0]  ALU_branch_control_out,
    output wire        mux1_sel_out,
    output wire        JTU_mux_sel_out,

    // MEM control signals
    output wire [2:0]  data_format_out,
    output wire        datamem_write_out,
    output wire        jump_flag_out,

    // WB control signals
    output wire [1:0]  mux0_sel_out,
    output wire        reg_file_write_out,
    output wire [4:0]  reg_file_write_address_out,

    // Read addresses to be given to the forwarding unit
    output wire [4:0]  register_file_read_address_0_out,
    output wire [4:0]  register_file_read_address_1_out,

    // Data
    output wire [31:0] register_file_output_0_out,
    output wire [31:0] register_file_output_1_out,
    output wire [31:0] immediate_out,
    output wire [31:0] instruction_address_out
);

    // Constant enable/load signal ('1')
    wire enable = 1'b1;

    // EX control signals registers
    reg4b ALU_operation_reg (
        .reg_in(ALU_operation_in), .load(enable), .clock(clock), .clear(clear), .reg_out(ALU_operation_out)
    );
    reg1b ALU_branch_reg (
        .reg_in(ALU_branch_in), .load(enable), .clock(clock), .clear(clear), .reg_out(ALU_branch_out)
    );
    reg3b ALU_branch_control_reg (
        .reg_in(ALU_branch_control_in), .load(enable), .clock(clock), .clear(clear), .reg_out(ALU_branch_control_out)
    );
    reg1b mux1_sel_reg (
        .reg_in(mux1_sel_in), .load(enable), .clock(clock), .clear(clear), .reg_out(mux1_sel_out)
    );
    reg1b JTU_mux_sel_reg (
        .reg_in(JTU_mux_sel_in), .load(enable), .clock(clock), .clear(clear), .reg_out(JTU_mux_sel_out)
    );

    // MEM control signals registers
    reg3b data_format_reg (
        .reg_in(data_format_in), .load(enable), .clock(clock), .clear(clear), .reg_out(data_format_out)
    );
    reg1b datamem_write_reg (
        .reg_in(datamem_write_in), .load(enable), .clock(clock), .clear(clear), .reg_out(datamem_write_out)
    );
    reg1b jump_flag_reg (
        .reg_in(jump_flag_in), .load(enable), .clock(clock), .clear(clear), .reg_out(jump_flag_out)
    );

    // WB control signals registers
    reg2b mux0_sel_reg (
        .reg_in(mux0_sel_in), .load(enable), .clock(clock), .clear(clear), .reg_out(mux0_sel_out)
    );
    reg1b reg_file_write_reg (
        .reg_in(reg_file_write_in), .load(enable), .clock(clock), .clear(clear), .reg_out(reg_file_write_out)
    );
    reg5b reg_file_write_address_reg (
        .reg_in(reg_file_write_address_in), .load(enable), .clock(clock), .clear(clear), .reg_out(reg_file_write_address_out)
    );

    // Data registers
    reg32b register_file_output_0_reg (
        .reg_in(register_file_output_0_in), .load(enable), .clock(clock), .clear(clear), .reg_out(register_file_output_0_out)
    );
    reg32b register_file_output_1_reg (
        .reg_in(register_file_output_1_in), .load(enable), .clock(clock), .clear(clear), .reg_out(register_file_output_1_out)
    );
    reg32b immediate_reg (
        .reg_in(immediate_in), .load(enable), .clock(clock), .clear(clear), .reg_out(immediate_out)
    );
    reg32b instruction_address_reg (
        .reg_in(instruction_address_in), .load(enable), .clock(clock), .clear(clear), .reg_out(instruction_address_out)
    );

    // Read addresses to be given to the forwarding unit
    reg5b register_file_read_address_0_reg (
        .reg_in(register_file_read_address_0_in), .load(enable), .clock(clock), .clear(clear), .reg_out(register_file_read_address_0_out)
    );
    reg5b register_file_read_address_1_reg (
        .reg_in(register_file_read_address_1_in), .load(enable), .clock(clock), .clear(clear), .reg_out(register_file_read_address_1_out)
    );

endmodule