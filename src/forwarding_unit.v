`timescale 1ns / 1ps

module forwarding_unit (
    input  wire [4:0] reg_file_read_address_0_ID_EX,
    input  wire [4:0] reg_file_read_address_1_ID_EX,

    input  wire       reg_file_write_EX_MEM,
    input  wire [4:0] reg_file_write_address_EX_MEM,
    input  wire [1:0] mux0_sel_EX_MEM,

    input  wire       reg_file_write_MEM_WB,
    input  wire [4:0] reg_file_write_address_MEM_WB,
    input  wire [1:0] mux0_sel_MEM_WB,

    output reg  [2:0] forward_mux_0_control,
    output reg  [2:0] forward_mux_1_control
);

    // Forwarding logic for Register Source 1 (rs1 / read_address_0)
    always @(*) begin
        if ((mux0_sel_EX_MEM == 2'b00) && reg_file_write_EX_MEM && 
            (reg_file_read_address_0_ID_EX == reg_file_write_address_EX_MEM) && 
            (reg_file_read_address_0_ID_EX != 5'b00000)) begin
            forward_mux_0_control = 3'b001;

        end else if ((mux0_sel_EX_MEM == 2'b01) && reg_file_write_EX_MEM && 
                 (reg_file_read_address_0_ID_EX == reg_file_write_address_EX_MEM) && 
                 (reg_file_read_address_0_ID_EX != 5'b00000)) begin
            forward_mux_0_control = 3'b010;

        end else if ((mux0_sel_MEM_WB == 2'b00) && reg_file_write_MEM_WB && 
                 (reg_file_read_address_0_ID_EX == reg_file_write_address_MEM_WB) && 
                 (reg_file_read_address_0_ID_EX != 5'b00000)) begin
            forward_mux_0_control = 3'b011;

        end else if ((mux0_sel_MEM_WB == 2'b01) && reg_file_write_MEM_WB && 
                 (reg_file_read_address_0_ID_EX == reg_file_write_address_MEM_WB) && 
                 (reg_file_read_address_0_ID_EX != 5'b00000)) begin
            forward_mux_0_control = 3'b100;

        end else begin
            forward_mux_0_control = 3'b000;
        end
    end

    // Forwarding logic for Register Source 2 (rs2 / read_address_1)
    always @(*) begin
        if ((mux0_sel_EX_MEM == 2'b00) && reg_file_write_EX_MEM && 
            (reg_file_read_address_1_ID_EX == reg_file_write_address_EX_MEM) && 
            (reg_file_read_address_1_ID_EX != 5'b00000)) begin
            forward_mux_1_control = 3'b001;

        end else if ((mux0_sel_EX_MEM == 2'b01) && reg_file_write_EX_MEM && 
                 (reg_file_read_address_1_ID_EX == reg_file_write_address_EX_MEM) && 
                 (reg_file_read_address_1_ID_EX != 5'b00000)) begin
            forward_mux_1_control = 3'b010;

        end else if ((mux0_sel_MEM_WB == 2'b00) && reg_file_write_MEM_WB && 
                 (reg_file_read_address_1_ID_EX == reg_file_write_address_MEM_WB) && 
                 (reg_file_read_address_1_ID_EX != 5'b00000)) begin
            forward_mux_1_control = 3'b011;

        end else if ((mux0_sel_MEM_WB == 2'b01) && reg_file_write_MEM_WB && 
                 (reg_file_read_address_1_ID_EX == reg_file_write_address_MEM_WB) && 
                 (reg_file_read_address_1_ID_EX != 5'b00000)) begin
            forward_mux_1_control = 3'b100;

        end else begin
            forward_mux_1_control = 3'b000;
        end
    end

endmodule