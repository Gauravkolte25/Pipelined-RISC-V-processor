`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2026 02:16:04 AM
// Design Name: 
// Module Name: tb_microcontroller
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

module tb_microcontroller;

    // Parameter definitions
    parameter CLK_PERIOD = 10; // 100 MHz clock frequency

    // Inputs to microcontroller
    reg clock;
    reg reset;

    // Debug Outputs from microcontroller
    wire [31:0] debug_pc_output;
    wire [31:0] debug_regfile_x31_output;
    wire [31:0] debug_regfile_x1_output;
    wire [31:0] debug_regfile_x2_output;
    wire [31:0] debug_regfile_x30_output;
    wire [31:0] debug_ALU_output;
    wire        debug_regfile_write;
    wire [31:0] debug_ALU_input_0;
    wire [31:0] debug_ALU_input_1;
    wire [4:0]  debug_reg_file_read_address_0;
    wire [4:0]  debug_reg_file_read_address_1;
    wire [1:0]  debug_mux0_sel;
    wire [31:0] debug_immediate;
    wire [3:0]  debug_ALU_operation;
    wire [2:0]  debug_forward_mux_0;
    wire [2:0]  debug_forward_mux_1;
    wire [4:0]  debug_reg_file_read_address_0_ID_EXE;
    wire [4:0]  debug_reg_file_write_address_EX_MEM;
    wire [1:0]  debug_mux0_sel_MEM_WB;
    wire        debug_reg_file_write_MEM_WB;
    wire [4:0]  debug_reg_file_write_address_MEM_WB;
    wire [31:0] debug_ALU_output_MEM_WB;
    wire [31:0] debug_ALU_output_EX_MEM;
    wire [31:0] debug_register_file_output_0;
    wire [31:0] debug_register_file_output_1;
    wire [31:0] debug_register_file_output_0_ID_EX;
    wire [31:0] debug_register_file_output_1_ID_EX;
    wire [31:0] debug_instruction;

    // Instantiate Unit Under Test (UUT)
    microcontroller uut (
        .clock                                (clock),
        .reset                                (reset),
        .debug_pc_output                      (debug_pc_output),
        .debug_regfile_x31_output             (debug_regfile_x31_output),
        .debug_regfile_x1_output              (debug_regfile_x1_output),
        .debug_regfile_x2_output              (debug_regfile_x2_output),
        .debug_regfile_x30_output             (debug_regfile_x30_output),  
        .debug_ALU_output                     (debug_ALU_output),
        .debug_regfile_write                  (debug_regfile_write),
        .debug_ALU_input_0                    (debug_ALU_input_0),
        .debug_ALU_input_1                    (debug_ALU_input_1),
        .debug_reg_file_read_address_0        (debug_reg_file_read_address_0),
        .debug_reg_file_read_address_1        (debug_reg_file_read_address_1),
        .debug_mux0_sel                       (debug_mux0_sel),
        .debug_immediate                      (debug_immediate),
        .debug_ALU_operation                  (debug_ALU_operation),
        .debug_forward_mux_0                  (debug_forward_mux_0),
        .debug_forward_mux_1                  (debug_forward_mux_1),
        .debug_reg_file_read_address_0_ID_EXE (debug_reg_file_read_address_0_ID_EXE),
        .debug_reg_file_write_address_EX_MEM  (debug_reg_file_write_address_EX_MEM),
        .debug_mux0_sel_MEM_WB                (debug_mux0_sel_MEM_WB),
        .debug_reg_file_write_MEM_WB          (debug_reg_file_write_MEM_WB),
        .debug_reg_file_write_address_MEM_WB  (debug_reg_file_write_address_MEM_WB),
        .debug_ALU_output_MEM_WB              (debug_ALU_output_MEM_WB),
        .debug_ALU_output_EX_MEM              (debug_ALU_output_EX_MEM),
        .debug_register_file_output_0         (debug_register_file_output_0),
        .debug_register_file_output_1         (debug_register_file_output_1),
        .debug_register_file_output_0_ID_EX   (debug_register_file_output_0_ID_EX),
        .debug_register_file_output_1_ID_EX   (debug_register_file_output_1_ID_EX),
        .debug_instruction                    (debug_instruction)
    );

    // Clock generation (100 MHz toggle)
    always #(CLK_PERIOD / 2) clock = ~clock;

    // Initial sequence
    initial begin
        // Initialize signals
        clock = 0;
        reset = 1;

        // Display console header
        $display("-------------------------------------------------------------------------");
        $display("Time (ns) | Reset |    PC    | Instruction | x1 (hex) | x2 (hex) | x31 (hex)  | x30 (hex)");
        $display("-------------------------------------------------------------------------");

        // Hold reset active for 2 clock cycles
        #(CLK_PERIOD * 2);
        reset = 0;

        // Run simulation for 500 ns
        #(CLK_PERIOD * 50);

        $display("-------------------------------------------------------------------------");
        $display("Simulation Finished.");


        $finish;

    end
    // Console output monitor (logs key signals on every positive clock edge)
    always @(posedge clock) begin
        if (!reset) begin
            $display("%9t |   %b   | %8h |  %8h   | %8h | %8h | %8h | %8h",
                     $time, reset, debug_pc_output, debug_instruction,
                     debug_regfile_x1_output, debug_regfile_x2_output, debug_regfile_x31_output, debug_regfile_x30_output);
        end

    end

endmodule