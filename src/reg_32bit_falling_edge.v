`timescale 1ns / 1ps

module reg32b_falling_edge (
    input  wire [31:0] reg_in,
    input  wire       load,
    input  wire       clock,
    input  wire       clear,
    output reg  [31:0] reg_out
);

    always @(negedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 32'd0;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule