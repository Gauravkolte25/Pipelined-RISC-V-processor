`timescale 1ns / 1ps

module datamem (
    input  wire        clock,
    input  wire        load,
    input  wire [15:0] address,
    input  wire [7:0]  input_data,
    output wire [7:0]  output_data
);

    // 65,536 depth x 8-bit width memory array (2^16 locations)
    reg [7:0] RAM [0:65535];

    // Synchronous Writes on Falling Clock Edge
    always @(negedge clock) begin
        if (load) begin
            RAM[address] <= input_data;
        end
    end

    // Asynchronous / Combinational Reads
    assign output_data = RAM[address];

endmodule