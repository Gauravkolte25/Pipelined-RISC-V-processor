`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2026 03:12:46 AM
// Design Name: 
// Module Name: tb_progmem
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

module tb_progmem_pc_check;

    // Clock and Reset Signals
    reg clock;
    reg reset;

    // Outputs from Datapath/PC/Progmem Pipeline
    wire [31:0] pc_output;
    wire [31:0] pc_next_address;
    wire [31:0] progmem_output;
    wire [31:0] instruction_if_id;

    // Clock Generation: 100MHz (10ns period)
    initial clock = 0;
    always #5 clock = ~clock;

    //--------------------------------------------------------------------------
    // Unit Under Test (UUT) Instantiations
    //--------------------------------------------------------------------------

    // 1. Program Counter Unit
    program_counter program_counter_0 (
        .clock        (clock),
        .clear        (reset),
        .mux_sel      (1'b0),                 // Force 0 for simple sequential increment (PC + 4)
        .address_in_0 (pc_output + 32'd4),
        .address_in_1 (32'h00000000),         // No branch target needed for this test
        .next_address (pc_next_address),
        .address_out  (pc_output)
    );

    // 2. Program Memory Interface Unit
    progmem_interface progmem_module_0 (
        .clock        (clock),
        .byte_address (pc_next_address),
        .output_data  (progmem_output)
    );

    // 3. IF/ID Pipeline Register Unit
    IF_ID_DIV IF_ID_PLR (
        .clock                  (clock),
        .clear                  (reset),
        .instruction_address_in (pc_output),
        .instruction_data_in    (progmem_output),
        .instruction_address_out(),
        .instruction_data_out   (instruction_if_id)
    );

    //--------------------------------------------------------------------------
    // Test Procedure & Verification
    //--------------------------------------------------------------------------
    initial begin
        // Display Table Header in Console
        $display("----------------------------------------------------------------------------------");
        $display(" Time (ns) | Reset |    PC Output   |   PC Next Addr | ProgMem Output | IF/ID Inst Out ");
        $display("----------------------------------------------------------------------------------");

        // Step 1: Initialize and Assert Reset
        reset = 1;
        #15; // Hold reset for 1.5 clock cycles

        // Step 2: Release Reset (PC begins incrementing)
        @(posedge clock);
        #1; 
        reset = 0;

        // Step 3: Run for 8 Clock Cycles and Monitor Outputs
        repeat (8) begin
            @(posedge clock);
            #1; // Delay slightly after edge for stable signal reading
            $display("%9t |   %b   | 0x%h | 0x%h   |   0x%h   |   0x%h", 
                     $time, reset, pc_output, pc_next_address, progmem_output, instruction_if_id);
        end

        // End Simulation
        $display("----------------------------------------------------------------------------------");
        $finish;
    end

endmodule
