`timescale 1ns / 1ps

module adder (
    input  wire [31:0] input_0,
    input  wire [31:0] input_1,
    output wire [31:0] output_0
);

    assign output_0 = input_0 + input_1;

endmodule