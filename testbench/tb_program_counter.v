`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2026 02:28:16 AM
// Design Name: 
// Module Name: tb_program_counter
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

module tb_program_counter;

    // Inputs to program_counter
    reg        clock;
    reg        clear;
    reg        mux_sel;
    reg [31:0] address_in_0;
    reg [31:0] address_in_1;

    // Outputs from program_counter
    wire [31:0] next_address;
    wire [31:0] address_out;

    // Instantiate Unit Under Test (UUT)
    program_counter uut (
        .clock        (clock),
        .clear        (clear),
        .mux_sel      (mux_sel),
        .address_in_0 (address_in_0),
        .address_in_1 (address_in_1),
        .next_address (next_address),
        .address_out  (address_out)
    );

    // Clock Generation: 100 MHz (10ns period)
    initial clock = 0;
    always #5 clock = ~clock;

    // Continuously simulate PC + 4 logic feeding address_in_0
    always @(*) begin
        address_in_0 = address_out + 32'd4;
    end

    // Test Procedure
    initial begin
        $display("-----------------------------------------------------------------------------------");
        $display(" Time (ns) | Clear | Mux_Sel | Address_In_0 | Address_In_1 | Next_Address | PC Output ");
        $display("-----------------------------------------------------------------------------------");

        // 1. Initial State & Reset Test
        clear = 1;
        mux_sel = 0;
        address_in_1 = 32'h000000A0; // Jump target sample (0xA0)
        #15; // Hold reset through a clock edge

        $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (Reset active)", 
                 $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);

        // 2. Release Reset -> Sequential PC Increment (PC + 4)
        @(posedge clock);
        #1; 
        clear = 0;

        repeat (4) begin
            @(posedge clock);
            #1;
            $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (PC + 4)", 
                     $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);
        end

        // 3. Test Jump/Branch Target Selection (mux_sel = 1)
        @(posedge clock);
        #1;
        mux_sel = 1; // Take jump to address_in_1 (0xA0)
        $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (Mux set to Jump Target)", 
                 $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);

        @(posedge clock);
        #1;
        mux_sel = 0; // Clear jump signal, continue sequentially from 0xA0
        $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (Jump Taken)", 
                 $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);

        repeat (2) begin
            @(posedge clock);
            #1;
            $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (Sequential from Jump)", 
                     $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);
        end

        // 4. Assert Reset Mid-Execution
        @(posedge clock);
        #1;
        clear = 1;
        #1;
        $display("%9t |   %b   |    %b    |  0x%h  |  0x%h  |  0x%h  | 0x%h (Reset re-asserted)", 
                 $time, clear, mux_sel, address_in_0, address_in_1, next_address, address_out);

        $display("-----------------------------------------------------------------------------------");
        $finish;
    end

endmodule