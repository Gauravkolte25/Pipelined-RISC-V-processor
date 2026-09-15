`timescale 1ns / 1ps


module reg4b (
    input  wire [3:0] reg_in,
    input  wire       load,
    input  wire       clock,
    input  wire       clear,
    output reg  [3:0] reg_out
);

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 4'b0000;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule