`timescale 1ns / 1ps

module reg5b (
    input  wire [4:0] reg_in,
    input  wire       load,
    input  wire       clock,
    input  wire       clear,
    output reg  [4:0] reg_out
);

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            reg_out <= 5'b00000;
        end else if (load) begin
            reg_out <= reg_in;
        end
    end

endmodule