`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 01:24:01 PM
// Design Name: 
// Module Name: ALU
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

module ALU (
    input  wire [31:0] input_0,
    input  wire [31:0] input_1,
    input  wire [3:0]  operation,
    input  wire        branch,
    input  wire [2:0]  ALU_branch_control,
    output reg         ALU_branch_response,
    output reg  [31:0] ALU_output
);

    // Wire inputs as signed to allow direct signed comparisons and arithmetic shifts
    wire signed [31:0] signed_input_0 = input_0;
    wire signed [31:0] signed_input_1 = input_1;

    // Shift amounts in RISC-V only use the lower 5 bits of input_1
    wire [4:0] shift_amt = input_1[4:0];

    // Branch Evaluation Logic
    always @(*) begin
        if (branch) begin
            case (ALU_branch_control)
                3'b000: ALU_branch_response = (input_0 == input_1);                     // BEQ
                3'b001: ALU_branch_response = (input_0 != input_1);                     // BNE
                3'b100: ALU_branch_response = (signed_input_0 < signed_input_1);        // BLT
                3'b101: ALU_branch_response = (signed_input_0 >= signed_input_1);       // BGE
                3'b110: ALU_branch_response = (input_0 < input_1);                     // BLTU
                3'b111: ALU_branch_response = (input_0 >= input_1);                    // BGEU
                default: ALU_branch_response = 1'b0;
            endcase
        end else begin
            ALU_branch_response = 1'b0;
        end
    end

    // Standard ALU Operations
    always @(*) begin
        if (!branch) begin
            case (operation)
                4'b0000: ALU_output = input_0 + input_1;                                // ADD
                4'b1000: ALU_output = input_0 - input_1;                                // SUB
                4'b0001: ALU_output = input_0 << shift_amt;                             // SLL
                4'b0010: ALU_output = (signed_input_0 < signed_input_1) ? 32'd1 : 32'd0; // SLT
                4'b0011: ALU_output = (input_0 < input_1) ? 32'd1 : 32'd0;               // SLTU
                4'b0100: ALU_output = input_0 ^ input_1;                                // XOR
                4'b0101: ALU_output = input_0 >> shift_amt;                             // SRL
                4'b1101: ALU_output = signed_input_0 >>> shift_amt;                     // SRA
                4'b0110: ALU_output = input_0 | input_1;                                // OR
                4'b0111: ALU_output = input_0 & input_1;                                // AND
                default: ALU_output = 32'h00000000;
            endcase
        end else begin
            ALU_output = 32'h00000000;
        end
    end

endmodule