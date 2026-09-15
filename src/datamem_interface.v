`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:24:01 PM
// Design Name: 
// Module Name: datamem_interface
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

module datamem_interface (
    input  wire [31:0] input_data,
    input  wire [31:0] byte_address,
    input  wire [2:0]  data_format,
    input  wire        clock,
    input  wire        load,
    input  wire        clear,
    output reg  [31:0] output_data
);

    reg  [3:0] internal_load;

    reg  [7:0] memory_input_0;
    reg  [7:0] memory_input_1;
    reg  [7:0] memory_input_2;
    reg  [7:0] memory_input_3;

    wire [7:0] memory_output_0;
    wire [7:0] memory_output_1;
    wire [7:0] memory_output_2;
    wire [7:0] memory_output_3;

    wire [31:0] membank_address;
    wire [1:0]  byte_starting_position;

    // Address calculations
    assign membank_address        = byte_address >> 2;
    assign byte_starting_position = byte_address[1:0];

    // Data alignment and formatting process
    always @(*) begin
        // Default assignments to prevent latches
        internal_load  = 4'b0000;
        memory_input_0 = 8'h00;
        memory_input_1 = 8'h00;
        memory_input_2 = 8'h00;
        memory_input_3 = 8'h00;
        output_data    = 32'h00000000;

        if (load) begin
            // Memory Write Operations
            case (data_format)
                3'b000: begin // Word operation
                    if (byte_starting_position == 2'b00) begin
                        internal_load  = 4'b1111;
                        memory_input_3 = input_data[31:24];
                        memory_input_2 = input_data[23:16];
                        memory_input_1 = input_data[15:8];
                        memory_input_0 = input_data[7:0];
                    end
                end

                3'b001, 3'b010: begin // Signed / Unsigned halfword
                    if (byte_starting_position == 2'b00) begin
                        internal_load  = 4'b0011;
                        memory_input_1 = input_data[15:8];
                        memory_input_0 = input_data[7:0];
                    end else if (byte_starting_position == 2'b10) begin
                        internal_load  = 4'b1100;
                        memory_input_3 = input_data[15:8];
                        memory_input_2 = input_data[7:0];
                    end
                end

                3'b011, 3'b100: begin // Signed / Unsigned byte
                    if (byte_starting_position == 2'b00) begin
                        internal_load  = 4'b0001;
                        memory_input_0 = input_data[7:0];
                    end else if (byte_starting_position == 2'b01) begin
                        internal_load  = 4'b0010;
                        memory_input_1 = input_data[7:0];
                    end else if (byte_starting_position == 2'b10) begin
                        internal_load  = 4'b0100;
                        memory_input_2 = input_data[7:0];
                    end else if (byte_starting_position == 2'b11) begin
                        internal_load  = 4'b1000; // Fixed double assignment bug from VHDL source
                        memory_input_3 = input_data[7:0];
                    end
                end

                default: begin
                    internal_load  = 4'b0000;
                    memory_input_3 = 8'h00;
                    memory_input_2 = 8'h00;
                    memory_input_1 = 8'h00;
                    memory_input_0 = 8'h00;
                end
            endcase

        end else begin
            // Memory Read Operations
            case (data_format)
                3'b000: begin // Word operation
                    if (byte_starting_position == 2'b00) begin
                        output_data = {memory_output_3, memory_output_2, memory_output_1, memory_output_0};
                    end
                end

                3'b001: begin // Signed halfword (sign extension)
                    if (byte_starting_position == 2'b00) begin
                        output_data = {{16{memory_output_1[7]}}, memory_output_1, memory_output_0};
                    end else if (byte_starting_position == 2'b10) begin
                        output_data = {{16{memory_output_3[7]}}, memory_output_3, memory_output_2};
                    end
                end

                3'b010: begin // Unsigned halfword (zero extension)
                    if (byte_starting_position == 2'b00) begin
                        output_data = {16'h0000, memory_output_1, memory_output_0};
                    end else if (byte_starting_position == 2'b10) begin
                        output_data = {16'h0000, memory_output_3, memory_output_2};
                    end
                end

                3'b011: begin // Signed byte (sign extension)
                    case (byte_starting_position)
                        2'b00: output_data = {{24{memory_output_0[7]}}, memory_output_0};
                        2'b01: output_data = {{24{memory_output_1[7]}}, memory_output_1};
                        2'b10: output_data = {{24{memory_output_2[7]}}, memory_output_2};
                        2'b11: output_data = {{24{memory_output_3[7]}}, memory_output_3};
                    endcase
                end

                3'b100: begin // Unsigned byte (zero extension)
                    case (byte_starting_position)
                        2'b00: output_data = {24'h000000, memory_output_0};
                        2'b01: output_data = {24'h000000, memory_output_1};
                        2'b10: output_data = {24'h000000, memory_output_2};
                        2'b11: output_data = {24'h000000, memory_output_3};
                    endcase
                end

                default: output_data = 32'h00000000;
            endcase
        end
    end

    // Memory Bank Instantiations
    datamem datamem_3 (
        .clock       (clock),
        .load        (internal_load[3]),
        .address     (membank_address[15:0]),
        .input_data  (memory_input_3),
        .output_data (memory_output_3)
    );

    datamem datamem_2 (
        .clock       (clock),
        .load        (internal_load[2]),
        .address     (membank_address[15:0]),
        .input_data  (memory_input_2),
        .output_data (memory_output_2)
    );

    datamem datamem_1 (
        .clock       (clock),
        .load        (internal_load[1]),
        .address     (membank_address[15:0]),
        .input_data  (memory_input_1),
        .output_data (memory_output_1)
    );

    datamem datamem_0 (
        .clock       (clock),
        .load        (internal_load[0]),
        .address     (membank_address[15:0]),
        .input_data  (memory_input_0),
        .output_data (memory_output_0)
    );

endmodule