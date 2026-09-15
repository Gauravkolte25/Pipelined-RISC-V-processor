`timescale 1ns / 1ps

module register_file (
    input  wire [31:0] write_data,
    input  wire [4:0]  write_address,
    input  wire [4:0]  read_address_0,
    input  wire [4:0]  read_address_1,
    input  wire        write_control,
    input  wire        clock,
    input  wire        clear,
    output wire [31:0] output_data_0,
    output wire [31:0] output_data_1,
    output wire [31:0] debug_x31_output,
    output wire [31:0] debug_x1_output,
    output wire [31:0] debug_x2_output,
    output wire [31:0] debug_x30_output
);

    // Decoder load signals
    reg [31:0] internal_reg_load;

    // Register outputs to multiplexers
    wire [31:0] x_out [0:31];

    //-------------------------------------------------------------------------
    // 1. Write Address Decoder
    //-------------------------------------------------------------------------
    always @(*) begin
        if (write_control) begin
            internal_reg_load = 32'b1 << write_address;
        end else begin
            internal_reg_load = 32'b0;
        end
    end

    //-------------------------------------------------------------------------
    // 2. Register Instantiations (Named Mapping)
    //-------------------------------------------------------------------------
    // Register x0: Hardwired to 0 per RISC-V specification
    reg32b_falling_edge reg_x0 (
        .reg_in  (32'h00000000),
        .load    (1'b1),
        .clock   (clock),
        .clear   (clear),
        .reg_out (x_out[0])
    );

    // Registers x1 through x31
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : gen_registers
            reg32b_falling_edge reg_inst (
                .reg_in  (write_data),
                .load    (internal_reg_load[i]),
                .clock   (clock),
                .clear   (clear),
                .reg_out (x_out[i])
            );
        end
    endgenerate

    //-------------------------------------------------------------------------
    // 3. Read Multiplexer Instantiations (Named Mapping)
    //-------------------------------------------------------------------------
    mux_32_1 output_1_mux (
        .selection (read_address_0),
        .input_0   (x_out[0]),  .input_1   (x_out[1]),  .input_2   (x_out[2]),  .input_3   (x_out[3]),
        .input_4   (x_out[4]),  .input_5   (x_out[5]),  .input_6   (x_out[6]),  .input_7   (x_out[7]),
        .input_8   (x_out[8]),  .input_9   (x_out[9]),  .input_10  (x_out[10]), .input_11  (x_out[11]),
        .input_12  (x_out[12]), .input_13  (x_out[13]), .input_14  (x_out[14]), .input_15  (x_out[15]),
        .input_16  (x_out[16]), .input_17  (x_out[17]), .input_18  (x_out[18]), .input_19  (x_out[19]),
        .input_20  (x_out[20]), .input_21  (x_out[21]), .input_22  (x_out[22]), .input_23  (x_out[23]),
        .input_24  (x_out[24]), .input_25  (x_out[25]), .input_26  (x_out[26]), .input_27  (x_out[27]),
        .input_28  (x_out[28]), .input_29  (x_out[29]), .input_30  (x_out[30]), .input_31  (x_out[31]),
        .output_0  (output_data_0)
    );

    mux_32_1 output_2_mux (
        .selection (read_address_1),
        .input_0   (x_out[0]),  .input_1   (x_out[1]),  .input_2   (x_out[2]),  .input_3   (x_out[3]),
        .input_4   (x_out[4]),  .input_5   (x_out[5]),  .input_6   (x_out[6]),  .input_7   (x_out[7]),
        .input_8   (x_out[8]),  .input_9   (x_out[9]),  .input_10  (x_out[10]), .input_11  (x_out[11]),
        .input_12  (x_out[12]), .input_13  (x_out[13]), .input_14  (x_out[14]), .input_15  (x_out[15]),
        .input_16  (x_out[16]), .input_17  (x_out[17]), .input_18  (x_out[18]), .input_19  (x_out[19]),
        .input_20  (x_out[20]), .input_21  (x_out[21]), .input_22  (x_out[22]), .input_23  (x_out[23]),
        .input_24  (x_out[24]), .input_25  (x_out[25]), .input_26  (x_out[26]), .input_27  (x_out[27]),
        .input_28  (x_out[28]), .input_29  (x_out[29]), .input_30  (x_out[30]), .input_31  (x_out[31]),
        .output_0  (output_data_1)
    );

    //-------------------------------------------------------------------------
    // 4. Debug Outputs
    //-------------------------------------------------------------------------
    assign debug_x1_output  = x_out[1];
    assign debug_x2_output  = x_out[2];
    assign debug_x31_output = x_out[31];
    assign debug_x30_output = x_out[30];

endmodule