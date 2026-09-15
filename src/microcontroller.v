`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:57:25 PM
// Design Name: 
// Module Name: microcontroller
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


module microcontroller (
    input  wire        clock,
    input  wire        reset,

    // Debug Outputs
    output wire [31:0] debug_pc_output,
    output wire [31:0] debug_regfile_x31_output,
    output wire [31:0] debug_regfile_x1_output,
    output wire [31:0] debug_regfile_x2_output,
    output wire [31:0] debug_regfile_x30_output,
    output wire [31:0] debug_ALU_output,
    output wire        debug_regfile_write,
    output wire [31:0] debug_ALU_input_0,
    output wire [31:0] debug_ALU_input_1,
    output wire [4:0]  debug_reg_file_read_address_0,
    output wire [4:0]  debug_reg_file_read_address_1,
    output wire [1:0]  debug_mux0_sel,
    output wire [31:0] debug_immediate,
    output wire [3:0]  debug_ALU_operation,
    output wire [2:0]  debug_forward_mux_0,
    output wire [2:0]  debug_forward_mux_1,
    output wire [4:0]  debug_reg_file_read_address_0_ID_EXE,
    output wire [4:0]  debug_reg_file_write_address_EX_MEM,
    output wire [1:0]  debug_mux0_sel_MEM_WB,
    output wire        debug_reg_file_write_MEM_WB,
    output wire [4:0]  debug_reg_file_write_address_MEM_WB,
    output wire [31:0] debug_ALU_output_MEM_WB,
    output wire [31:0] debug_ALU_output_EX_MEM,
    output wire [31:0] debug_register_file_output_0,
    output wire [31:0] debug_register_file_output_1,
    output wire [31:0] debug_register_file_output_0_ID_EX,
    output wire [31:0] debug_register_file_output_1_ID_EX,
    output wire [31:0] debug_instruction
);

    // Internal Control Signals
    wire       IF_ID_flush;
    wire [4:0] reg_file_read_address_0;
    wire [4:0] reg_file_read_address_1;
    wire       reg_file_write;
    wire [4:0] reg_file_write_address;
    wire [31:0] immediate;
    wire [3:0] ALU_operation;
    wire       ALU_branch;
    wire [2:0] ALU_branch_control;
    wire       JTU_mux_sel;
    wire [2:0] data_format;
    wire       datamem_write;
    wire       jump_flag;
    wire [1:0] mux0_sel;
    wire       mux1_sel;
    wire [31:0] instruction;

    // Instantiate Controller
    controller controller_0 (
        .clock                   (clock),
        .reset                   (reset),
        .instruction             (instruction),
        .reg_file_read_address_0 (reg_file_read_address_0),
        .reg_file_read_address_1 (reg_file_read_address_1),
        .reg_file_write          (reg_file_write),
        .reg_file_write_address  (reg_file_write_address),
        .immediate               (immediate),
        .ALU_operation           (ALU_operation),
        .ALU_branch              (ALU_branch),
        .ALU_branch_control      (ALU_branch_control),
        .JTU_mux_sel             (JTU_mux_sel),
        .data_format             (data_format),
        .datamem_write           (datamem_write),
        .jump_flag               (jump_flag),
        .mux0_sel                (mux0_sel),
        .mux1_sel                (mux1_sel)
    );

    // Instantiate Datapath
    datapath datapath_0 (
        .clock                               (clock),
        .reset                               (reset),
        .reg_file_read_address_0             (reg_file_read_address_0),
        .reg_file_read_address_1             (reg_file_read_address_1),
        .reg_file_write                      (reg_file_write),
        .reg_file_write_address              (reg_file_write_address),
        .immediate                           (immediate),
        .ALU_operation                       (ALU_operation),
        .ALU_branch                          (ALU_branch),
        .ALU_branch_control                  (ALU_branch_control),
        .JTU_mux_sel                         (JTU_mux_sel),
        .data_format                         (data_format),
        .datamem_write                       (datamem_write),
        .jump_flag                           (jump_flag),
        .mux0_sel                            (mux0_sel),
        .mux1_sel                            (mux1_sel),
        .instruction                         (instruction),
        .debug_instruction_address           (debug_pc_output),
        .debug_regfile_x31_output            (debug_regfile_x31_output),
        .debug_regfile_x1_output             (debug_regfile_x1_output),
        .debug_regfile_x2_output             (debug_regfile_x2_output),
        .debug_regfile_x30_output            (debug_regfile_x30_output),
        .debug_ALU_output                    (debug_ALU_output),
        .debug_ALU_input_0                   (debug_ALU_input_0),
        .debug_ALU_input_1                   (debug_ALU_input_1),
        .debug_forward_mux_0                 (debug_forward_mux_0),
        .debug_forward_mux_1                 (debug_forward_mux_1),
        .debug_reg_file_read_address_0_ID_EXE(debug_reg_file_read_address_0_ID_EXE),
        .debug_reg_file_write_address_EX_MEM(debug_reg_file_write_address_EX_MEM),
        .debug_mux0_sel_MEM_WB               (debug_mux0_sel_MEM_WB),
        .debug_reg_file_write_MEM_WB         (debug_reg_file_write_MEM_WB),
        .debug_reg_file_write_address_MEM_WB (debug_reg_file_write_address_MEM_WB),
        .debug_ALU_output_MEM_WB             (debug_ALU_output_MEM_WB),
        .debug_ALU_output_EX_MEM             (debug_ALU_output_EX_MEM),
        .debug_register_file_output_0        (debug_register_file_output_0),
        .debug_register_file_output_1        (debug_register_file_output_1),
        .debug_register_file_output_0_ID_EX  (debug_register_file_output_0_ID_EX),
        .debug_register_file_output_1_ID_EX  (debug_register_file_output_1_ID_EX),
        .debug_instruction                   (debug_instruction)
    );

    // Debug Signal Assigns
    assign debug_regfile_write            = reg_file_write;
    assign debug_reg_file_read_address_0  = reg_file_read_address_0;
    assign debug_reg_file_read_address_1  = reg_file_read_address_1;
    assign debug_mux0_sel                 = mux0_sel;
    assign debug_immediate                = immediate;
    assign debug_ALU_operation            = ALU_operation;

endmodule
