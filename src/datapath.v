`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 11:04:27 AM
// Design Name: 
// Module Name: datapath
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

module datapath (
    input  wire        clock,
    input  wire        reset,
    input  wire [4:0]  reg_file_read_address_0,
    input  wire [4:0]  reg_file_read_address_1,
    input  wire        reg_file_write,
    input  wire [4:0]  reg_file_write_address,
    input  wire [31:0] immediate,
    input  wire [3:0]  ALU_operation,
    input  wire        ALU_branch,
    input  wire [2:0]  ALU_branch_control,
    input  wire        JTU_mux_sel,
    input  wire [2:0]  data_format,
    input  wire        datamem_write,
    input  wire        jump_flag,
    input  wire [1:0]  mux0_sel,
    input  wire        mux1_sel,
    
    inout  wire [31:0] instruction,

    output wire [31:0] debug_instruction_address,
    output wire [31:0] debug_regfile_x31_output,
    output wire [31:0] debug_regfile_x1_output,
    output wire [31:0] debug_regfile_x2_output,
    output wire [31:0] debug_regfile_x30_output,
    output wire [31:0] debug_ALU_output,
    output wire [31:0] debug_ALU_input_0,
    output wire [31:0] debug_ALU_input_1,
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

    // Internal Interconnect Signals
    wire [31:0] PC_output;
    wire [31:0] PC_next_address;
    wire [31:0] progmem_output;
    wire        flushing_unit_output;

    wire [31:0] mux_0_output;
    wire [31:0] mux_1_output;

    wire [31:0] register_file_output_0;
    wire [31:0] register_file_output_1;

    wire        ALU_branch_response;
    wire [31:0] ALU_output;
    wire [31:0] datamem_output;

    // IF/ID Pipeline Register Signals
    wire [31:0] instruction_address_IF_ID;
    wire [31:0] instruction_internal;

    // ID/EX Pipeline Register Signals
    wire [3:0]  ALU_operation_ID_EX;
    wire        ALU_branch_ID_EX;
    wire [2:0]  ALU_branch_control_ID_EX;
    wire        mux1_sel_ID_EX;
    wire        JTU_mux_sel_ID_EX;
    wire [2:0]  data_format_ID_EX;
    wire        datamem_write_ID_EX;
    wire        jump_flag_ID_EX;
    wire [1:0]  mux0_sel_ID_EX;
    wire        reg_file_write_ID_EX;
    wire [4:0]  reg_file_write_address_ID_EX;
    wire [4:0]  register_file_read_address_0_ID_EX;
    wire [4:0]  register_file_read_address_1_ID_EX;
    wire [31:0] register_file_output_0_ID_EX;
    wire [31:0] register_file_output_1_ID_EX;
    wire [31:0] immediate_ID_EX;
    wire [31:0] instruction_address_ID_EX;

    // Forwarding Unit Signals
    wire [2:0]  forward_mux_0_control;
    wire [2:0]  forward_mux_1_control;
    wire [31:0] forward_mux_0_output;
    wire [31:0] forward_mux_1_output;

    wire [31:0] JTU_output;

    // EX/MEM Pipeline Register Signals
    wire [2:0]  data_format_EX_MEM;
    wire        datamem_write_EX_MEM;
    wire        jump_flag_EX_MEM;
    wire [1:0]  mux0_sel_EX_MEM;
    wire        reg_file_write_EX_MEM;
    wire [4:0]  reg_file_write_address_EX_MEM;
    wire        ALU_branch_response_EX_MEM;
    wire [31:0] ALU_output_EX_MEM;
    wire [31:0] register_file_output_1_EX_MEM;
    wire [31:0] instruction_address_EX_MEM;

    // MEM/WB Pipeline Register Signals
    wire [1:0]  mux0_sel_MEM_WB;
    wire        reg_file_write_MEM_WB;
    wire [4:0]  reg_file_write_address_MEM_WB;
    wire [31:0] ALU_output_MEM_WB;
    wire [31:0] datamem_output_MEM_WB;
    wire [31:0] instruction_address_MEM_WB;

    // Debug Signals
    wire [31:0] debug_regfile_x31_output_signal;
    wire [31:0] debug_regfile_x1_output_signal;
    wire [31:0] debug_regfile_x2_output_signal;
    wire [31:0] debug_regfile_x30_output_signal;
    // Assign buffer instruction output
    assign instruction = instruction_internal;

    // Combined flushing signals
    wire flush_if_id;
    wire flush_id_ex;
    assign flush_if_id = reset | ALU_branch_response_EX_MEM;
    assign flush_id_ex = reset | ALU_branch_response_EX_MEM;

    //--------------------------------------------------------------------------
    // Module Instantiations
    //--------------------------------------------------------------------------

    program_counter program_counter_0 (
        .clear        (reset),
        .clock        (clock),
        .mux_sel      (ALU_branch_response | jump_flag_ID_EX),
        .address_in_0 (PC_output + 32'd4),
        .address_in_1 (JTU_output), // Fixed port name: address_in_2 -> address_in_1
        .next_address (PC_next_address),
        .address_out  (PC_output)
    );

    progmem_interface progmem_module_0 (
        .clock        (clock),
        .byte_address (PC_output),
        .output_data  (progmem_output)
    );

    IF_ID_DIV IF_ID_PLR (
        .clock                  (clock),
        .clear                  (flush_if_id),
        .instruction_address_in (PC_output),                 // Fixed port name to match IF_ID_DIV
        .instruction_data_in    (progmem_output),            // Fixed port name to match IF_ID_DIV
        .instruction_address_out(instruction_address_IF_ID), // Fixed port name to match IF_ID_DIV
        .instruction_data_out   (instruction_internal)       // Fixed port name to match IF_ID_DIV
    );

    MUX_3_1 mux_0 (
        .selection (mux0_sel_MEM_WB),
        .input_0   (ALU_output_MEM_WB),
        .input_1   (datamem_output_MEM_WB),
        .input_2   (instruction_address_MEM_WB + 32'd4),
        .output_0  (mux_0_output)
    );

    register_file register_file_0 (
        .write_data       (mux_0_output),
        .write_address    (reg_file_write_address_MEM_WB),
        .read_address_0   (reg_file_read_address_0),
        .read_address_1   (reg_file_read_address_1),
        .write_control    (reg_file_write_MEM_WB), // Fixed port name: write_enable -> write_control
        .clock            (clock),
        .clear            (reset),
        .output_data_0    (register_file_output_0), // Fixed port name: read_data_0 -> output_data_0
        .output_data_1    (register_file_output_1), // Fixed port name: read_data_1 -> output_data_1
        .debug_x31_output (debug_regfile_x31_output_signal), // Fixed debug port names
        .debug_x1_output  (debug_regfile_x1_output_signal),
        .debug_x2_output  (debug_regfile_x2_output_signal),
        .debug_x30_output (debug_regfile_x30_output_signal)
    );

    ID_EX_DIV ID_EX_PLR (
        .clock                               (clock),
        .clear                               (flush_id_ex), // Fixed port name: reset -> clear
        .ALU_operation_in                    (ALU_operation),
        .ALU_branch_in                       (ALU_branch),
        .ALU_branch_control_in               (ALU_branch_control),
        .mux1_sel_in                         (mux1_sel),
        .JTU_mux_sel_in                      (JTU_mux_sel),
        .data_format_in                      (data_format),
        .datamem_write_in                    (datamem_write),
        .jump_flag_in                        (jump_flag),
        .mux0_sel_in                         (mux0_sel),
        .reg_file_write_in                   (reg_file_write),
        .reg_file_write_address_in           (reg_file_write_address),
        .register_file_read_address_0_in     (reg_file_read_address_0),
        .register_file_read_address_1_in     (reg_file_read_address_1),
        .register_file_output_0_in           (register_file_output_0),
        .register_file_output_1_in           (register_file_output_1),
        .immediate_in                        (immediate),
        .instruction_address_in              (instruction_address_IF_ID),
        .ALU_operation_out                   (ALU_operation_ID_EX),
        .ALU_branch_out                      (ALU_branch_ID_EX),
        .ALU_branch_control_out              (ALU_branch_control_ID_EX),
        .mux1_sel_out                        (mux1_sel_ID_EX),
        .JTU_mux_sel_out                     (JTU_mux_sel_ID_EX),
        .data_format_out                     (data_format_ID_EX),
        .datamem_write_out                   (datamem_write_ID_EX),
        .jump_flag_out                       (jump_flag_ID_EX),
        .mux0_sel_out                        (mux0_sel_ID_EX),
        .reg_file_write_out                  (reg_file_write_ID_EX),
        .reg_file_write_address_out          (reg_file_write_address_ID_EX),
        .register_file_read_address_0_out    (register_file_read_address_0_ID_EX),
        .register_file_read_address_1_out    (register_file_read_address_1_ID_EX),
        .register_file_output_0_out          (register_file_output_0_ID_EX),
        .register_file_output_1_out          (register_file_output_1_ID_EX),
        .immediate_out                       (immediate_ID_EX),
        .instruction_address_out             (instruction_address_ID_EX)
    );

    forwarding_unit FU_0 (
        .reg_file_read_address_0_ID_EX   (register_file_read_address_0_ID_EX),
        .reg_file_read_address_1_ID_EX   (register_file_read_address_1_ID_EX),
        .reg_file_write_EX_MEM           (reg_file_write_EX_MEM),
        .reg_file_write_address_EX_MEM   (reg_file_write_address_EX_MEM),
        .mux0_sel_EX_MEM                 (mux0_sel_EX_MEM),
        .reg_file_write_MEM_WB           (reg_file_write_MEM_WB),
        .reg_file_write_address_MEM_WB   (reg_file_write_address_MEM_WB),
        .mux0_sel_MEM_WB                 (mux0_sel_MEM_WB),
        .forward_mux_0_control           (forward_mux_0_control),
        .forward_mux_1_control           (forward_mux_1_control)
    );

    mux_5_1 forward_mux_0 (
        .selection (forward_mux_0_control), // Fixed port name: sel -> selection
        .input_0   (register_file_output_0_ID_EX), // Fixed port names: in0..in4 -> input_0..input_4
        .input_1   (ALU_output_EX_MEM),
        .input_2   (datamem_output),
        .input_3   (ALU_output_MEM_WB),
        .input_4   (datamem_output_MEM_WB),
        .output_0  (forward_mux_0_output) // Fixed port name: out -> output_0
    );

    mux_5_1 forward_mux_1 (
        .selection (forward_mux_1_control),
        .input_0   (register_file_output_1_ID_EX),
        .input_1   (ALU_output_EX_MEM),
        .input_2   (datamem_output),
        .input_3   (ALU_output_MEM_WB),
        .input_4   (datamem_output_MEM_WB),
        .output_0  (forward_mux_1_output)
    );

    MUX_2_1 mux_1 (
        .selection (mux1_sel_ID_EX), // Fixed port names to match mux_2_1
        .input_0   (forward_mux_1_output),
        .input_1   (immediate_ID_EX),
        .output_0  (mux_1_output)
    );

    ALU ALU_0 (
        .input_0             (forward_mux_0_output),
        .input_1             (mux_1_output),
        .operation       (ALU_operation_ID_EX),
        .branch          (ALU_branch_ID_EX),
        .ALU_branch_control  (ALU_branch_control_ID_EX),
        .ALU_branch_response (ALU_branch_response),
        .ALU_output          (ALU_output)
    );

    jump_target_unit JTU_0 (
        .JTU_mux_sel               (JTU_mux_sel_ID_EX),
        .instruction_address_ID_EX (instruction_address_ID_EX),
        .register_file_output_0    (register_file_output_0_ID_EX),
        .immediate                 (immediate_ID_EX),
        .JTU_output                (JTU_output)
    );

    EX_MEM_DIV EX_MEM_PLR (
        .clock                           (clock),
        .clear                           (reset), // Fixed port name: reset -> clear
        .data_format_in                  (data_format_ID_EX),
        .datamem_write_in                (datamem_write_ID_EX),
        .jump_flag_in                    (jump_flag_ID_EX),
        .mux0_sel_in                     (mux0_sel_ID_EX),
        .reg_file_write_in               (reg_file_write_ID_EX),
        .reg_file_write_address_in       (reg_file_write_address_ID_EX),
        .ALU_output_in                   (ALU_output),
        .register_file_output_1_in         (forward_mux_1_output),
        .ALU_branch_response_in          (ALU_branch_response),
        .instruction_address_in          (instruction_address_ID_EX),
        .data_format_out                 (data_format_EX_MEM),
        .datamem_write_out               (datamem_write_EX_MEM),
        .jump_flag_out                   (jump_flag_EX_MEM),
        .mux0_sel_out                    (mux0_sel_EX_MEM),
        .reg_file_write_out              (reg_file_write_EX_MEM),
        .reg_file_write_address_out      (reg_file_write_address_EX_MEM),
        .ALU_output_out                  (ALU_output_EX_MEM),
        .register_file_output_1_out      (register_file_output_1_EX_MEM),
        .ALU_branch_response_out         (ALU_branch_response_EX_MEM),
        .instruction_address_out         (instruction_address_EX_MEM)
    );

    flushing_unit FLUSH (
        .clear                (reset), // Fixed port name: reset -> clear
        .clock                (clock),
        .flushing_control      (ALU_branch_response_EX_MEM | jump_flag_EX_MEM),
        .flushing_output (flushing_unit_output)
    );

    datamem_interface datamem_module_0 (
        .input_data   (register_file_output_1_EX_MEM),
        .byte_address      (ALU_output_EX_MEM),
        .data_format  (data_format_EX_MEM),
        .clock        (clock),
        .load (datamem_write_EX_MEM),
        .clear        (reset), // Fixed port name: reset -> clear
        .output_data    (datamem_output)
    );

    MEM_WB_DIV MEM_WB_PLR (
        .clock                           (clock),
        .clear                           (reset), // Fixed port name: reset -> clear
        .mux0_sel_in                     (mux0_sel_EX_MEM),
        .reg_file_write_in               (reg_file_write_EX_MEM),
        .reg_file_write_address_in       (reg_file_write_address_EX_MEM),
        .ALU_output_in                   (ALU_output_EX_MEM),
        .datamem_output_in               (datamem_output),
        .instruction_address_in          (instruction_address_EX_MEM),
        .mux0_sel_out                    (mux0_sel_MEM_WB),
        .reg_file_write_out              (reg_file_write_MEM_WB),
        .reg_file_write_address_out      (reg_file_write_address_MEM_WB),
        .ALU_output_out                  (ALU_output_MEM_WB),
        .datamem_output_out              (datamem_output_MEM_WB),
        .instruction_address_out         (instruction_address_MEM_WB)
    );

    //--------------------------------------------------------------------------
    // Debug Signal Assignments
    //--------------------------------------------------------------------------
    assign debug_instruction_address            = PC_output;
    assign debug_regfile_x31_output            = debug_regfile_x31_output_signal;
    assign debug_regfile_x1_output             = debug_regfile_x1_output_signal;
    assign debug_regfile_x2_output             = debug_regfile_x2_output_signal;
    assign debug_regfile_x30_output            = debug_regfile_x30_output_signal;
    assign debug_ALU_output                    = ALU_output;
    assign debug_ALU_input_0                   = forward_mux_0_output;
    assign debug_ALU_input_1                   = mux_1_output;
    assign debug_forward_mux_0                 = forward_mux_0_control;
    assign debug_forward_mux_1                 = forward_mux_1_control;
    assign debug_reg_file_read_address_0_ID_EXE = register_file_read_address_0_ID_EX;
    assign debug_reg_file_write_address_EX_MEM = reg_file_write_address_EX_MEM;
    assign debug_mux0_sel_MEM_WB               = mux0_sel_MEM_WB;
    assign debug_reg_file_write_MEM_WB         = reg_file_write_MEM_WB;
    assign debug_reg_file_write_address_MEM_WB = reg_file_write_address_MEM_WB;
    assign debug_ALU_output_MEM_WB             = ALU_output_MEM_WB;
    assign debug_ALU_output_EX_MEM             = ALU_output_EX_MEM;
    assign debug_register_file_output_0        = register_file_output_0;
    assign debug_register_file_output_1        = register_file_output_1;
    assign debug_register_file_output_0_ID_EX  = register_file_output_0_ID_EX;
    assign debug_register_file_output_1_ID_EX  = register_file_output_1_ID_EX;
    assign debug_instruction                    = progmem_output;

endmodule