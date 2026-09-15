`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 02:00:48 PM
// Design Name: 
// Module Name: controller
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

module controller (
    input  wire        clock,
    input  wire        reset,
    input  wire [31:0] instruction,

    output wire [4:0]  reg_file_read_address_0,
    output wire [4:0]  reg_file_read_address_1,
    output wire        reg_file_write,
    output wire [4:0]  reg_file_write_address,
    output wire [31:0] immediate,
    output wire [3:0]  ALU_operation,
    output wire        ALU_branch,
    output wire [2:0]  ALU_branch_control,
    output wire        JTU_mux_sel,
    output wire [2:0]  data_format,
    output wire        datamem_write,
    output wire        jump_flag,
    output wire [1:0]  mux0_sel,
    output wire        mux1_sel
);

    // Operational States
    localparam STATE_NORMAL = 1'b0;

    // Instruction Clusters
    localparam CLUSTER_INVALID  = 5'd0,
               CLUSTER_LOAD     = 5'd1,
               CLUSTER_STORE    = 5'd2,
               CLUSTER_MADD     = 5'd3,
               CLUSTER_BRANCH   = 5'd4,
               CLUSTER_LOAD_FP  = 5'd5,
               CLUSTER_STORE_FP = 5'd6,
               CLUSTER_MSUB     = 5'd7,
               CLUSTER_JALR     = 5'd8,
               CLUSTER_NMSUB    = 5'd9,
               CLUSTER_MISC_MEM = 5'd10,
               CLUSTER_AMO      = 5'd11,
               CLUSTER_NMADD    = 5'd12,
               CLUSTER_JAL      = 5'd13,
               CLUSTER_OP_IMM   = 5'd14,
               CLUSTER_OP       = 5'd15,
               CLUSTER_OP_FP    = 5'd16,
               CLUSTER_SYSTEM   = 5'd17,
               CLUSTER_AUIPC    = 5'd18,
               CLUSTER_LUI      = 5'd19,
               CLUSTER_OP_IMM_32= 5'd20,
               CLUSTER_OP_32    = 5'd21;

    // Opcodes
    localparam OP_INVALID  = 6'd0,  OP_LUI      = 6'd1,  OP_AUIPC    = 6'd2,  OP_JAL      = 6'd3,
               OP_JALR     = 6'd4,  OP_BEQ      = 6'd5,  OP_BNE      = 6'd6,  OP_BLT      = 6'd7,
               OP_BGE      = 6'd8,  OP_BLTU     = 6'd9,  OP_BGEU     = 6'd10, OP_LB       = 6'd11,
               OP_LH       = 6'd12, OP_LW       = 6'd13, OP_LBU      = 6'd14, OP_LHU      = 6'd15,
               OP_SB       = 6'd16, OP_SH       = 6'd17, OP_SW       = 6'd18, OP_ADDI     = 6'd19,
               OP_SLTI     = 6'd20, OP_SLTIU    = 6'd21, OP_XORI     = 6'd22, OP_ORI      = 6'd23,
               OP_ANDI     = 6'd24, OP_SLLI     = 6'd25, OP_SRLI     = 6'd26, OP_SRAI     = 6'd27,
               OP_ADD      = 6'd28, OP_SUB      = 6'd29, OP_INST_SLL = 6'd30, OP_SLT      = 6'd31,
               OP_SLTU     = 6'd32, OP_INST_XOR = 6'd33, OP_INST_SRL = 6'd34, OP_INST_SRA = 6'd35,
               OP_INST_OR  = 6'd36, OP_INST_AND = 6'd37, OP_FENCE    = 6'd38, OP_FENCEI   = 6'd39,
               OP_EXALL    = 6'd40, OP_EBREAK   = 6'd41, OP_CSRRW    = 6'd42, OP_CSRRS    = 6'd43,
               OP_CSRRC    = 6'd44, OP_CSRRSI   = 6'd45, OP_CSRRCI   = 6'd46;

    // State registers
    reg current_state = STATE_NORMAL;
    reg next_state    = STATE_NORMAL;

    // Decoded internal registers
    reg [4:0] decoded_cluster;
    reg [5:0] decoded_opcode;

    // Internal output signals
    reg [31:0] internal_immediate                 = 32'h00000000;
    reg [4:0]  internal_reg_file_read_address_0   = 5'b00000;
    reg [4:0]  internal_reg_file_read_address_1   = 5'b00000;
    reg        internal_reg_file_write            = 1'b0;
    reg [4:0]  internal_reg_file_write_address   = 5'b00000;
    reg [3:0]  internal_ALU_operation             = 4'b0000;
    reg        internal_ALU_branch                = 1'b0;
    reg [2:0]  internal_ALU_branch_control        = 3'b000;
    reg        internal_JTU_mux_sel               = 1'b0;
    reg [2:0]  internal_data_format               = 3'b000;
    reg        internal_datamem_write             = 1'b0;
    reg        internal_jump_flag                 = 1'b0;
    reg [1:0]  internal_mux0_sel                  = 2'b00;
    reg        internal_mux1_sel                  = 1'b0;

    // State Machine Synchronism Process
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            current_state <= STATE_NORMAL;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational Decoding & Control Logic Process
    always @(*) begin
        // Default assignments to avoid latches
        next_state                          = current_state;
        decoded_cluster                     = CLUSTER_INVALID;
        decoded_opcode                      = OP_INVALID;
        internal_reg_file_read_address_0    = 5'b00000;
        internal_reg_file_read_address_1    = 5'b00000;
        internal_reg_file_write             = 1'b0;
        internal_reg_file_write_address    = 5'b00000;
        internal_immediate                  = 32'h00000000;
        internal_ALU_operation              = 4'b0000;
        internal_ALU_branch                 = 1'b0;
        internal_ALU_branch_control         = 3'b000;
        internal_JTU_mux_sel                = 1'b0;
        internal_data_format                = 3'b000;
        internal_datamem_write              = 1'b0;
        internal_jump_flag                  = 1'b0;
        internal_mux0_sel                   = 2'b00;
        internal_mux1_sel                   = 1'b0;

        case (current_state)
            STATE_NORMAL: begin
                // Decoding cluster and opcode
                if (instruction[1:0] == 2'b00) begin
                    decoded_cluster = CLUSTER_INVALID;
                    decoded_opcode  = OP_INVALID;
                end else begin
                    case (instruction[4:2])
                        3'b000: begin
                            case (instruction[6:5])
                                2'b00: begin // LOAD
                                    decoded_cluster = CLUSTER_LOAD;
                                    case (instruction[14:12])
                                        3'b000: decoded_opcode = OP_LB;
                                        3'b001: decoded_opcode = OP_LH;
                                        3'b010: decoded_opcode = OP_LW;
                                        3'b100: decoded_opcode = OP_LBU;
                                        3'b101: decoded_opcode = OP_LHU;
                                        default: decoded_opcode = OP_INVALID;
                                    endcase
                                end
                                2'b01: begin // STORE
                                    decoded_cluster = CLUSTER_STORE;
                                    case (instruction[14:12])
                                        3'b000: decoded_opcode = OP_SB;
                                        3'b001: decoded_opcode = OP_SH;
                                        3'b010: decoded_opcode = OP_SW;
                                        default: decoded_opcode = OP_INVALID;
                                    endcase
                                end
                                2'b10: begin // MADD
                                    decoded_cluster = CLUSTER_INVALID;
                                    decoded_opcode  = OP_INVALID;
                                end
                                2'b11: begin // BRANCH
                                    decoded_cluster = CLUSTER_BRANCH;
                                    case (instruction[14:12])
                                        3'b000: decoded_opcode = OP_BEQ;
                                        3'b001: decoded_opcode = OP_BNE;
                                        3'b100: decoded_opcode = OP_BLT;
                                        3'b101: decoded_opcode = OP_BGE;
                                        3'b110: decoded_opcode = OP_BLTU;
                                        3'b111: decoded_opcode = OP_BGEU;
                                        default: decoded_opcode = OP_INVALID;
                                    endcase
                                end
                            endcase
                        end

                        3'b001: begin
                            case (instruction[6:5])
                                2'b00: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // LOAD-FP
                                2'b01: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // STORE-FP
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // MSUB
                                2'b11: begin // JALR
                                    decoded_cluster = CLUSTER_JALR;
                                    decoded_opcode  = OP_JALR;
                                end
                            endcase
                        end

                        3'b010: begin
                            case (instruction[6:5])
                                2'b00: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // Custom 0
                                2'b01: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // Custom 1
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // NMSUB
                                2'b11: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // Reserved
                            endcase
                        end

                        3'b011: begin
                            case (instruction[6:5])
                                2'b00: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // MISC-MEM
                                2'b01: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // AMO
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // NMADD
                                2'b11: begin // JAL
                                    decoded_cluster = CLUSTER_JAL;
                                    decoded_opcode  = OP_JAL;
                                end
                            endcase
                        end

                        3'b100: begin
                            case (instruction[6:5])
                                2'b00: begin // OP-IMM
                                    decoded_cluster = CLUSTER_OP_IMM;
                                    case (instruction[14:12])
                                        3'b000: decoded_opcode = OP_ADDI;
                                        3'b010: decoded_opcode = OP_SLTI;
                                        3'b011: decoded_opcode = OP_SLTIU;
                                        3'b100: decoded_opcode = OP_XORI;
                                        3'b110: decoded_opcode = OP_ORI;
                                        3'b111: decoded_opcode = OP_ANDI;
                                        3'b001: decoded_opcode = OP_SLLI;
                                        3'b101: begin
                                            case (instruction[30])
                                                1'b0: decoded_opcode = OP_SRLI;
                                                1'b1: decoded_opcode = OP_SRAI;
                                            endcase
                                        end
                                        default: decoded_opcode = OP_INVALID;
                                    endcase
                                end
                                2'b01: begin // OP
                                    decoded_cluster = CLUSTER_OP;
                                    case (instruction[14:12])
                                        3'b000: begin
                                            case (instruction[30])
                                                1'b0: decoded_opcode = OP_ADD;
                                                1'b1: decoded_opcode = OP_SUB;
                                            endcase
                                        end
                                        3'b001: decoded_opcode = OP_INST_SLL;
                                        3'b010: decoded_opcode = OP_SLT;
                                        3'b011: decoded_opcode = OP_SLTU;
                                        3'b100: decoded_opcode = OP_INST_XOR;
                                        3'b101: begin
                                            case (instruction[30])
                                                1'b0: decoded_opcode = OP_INST_SRL;
                                                1'b1: decoded_opcode = OP_INST_SRA;
                                            endcase
                                        end
                                        3'b110: decoded_opcode = OP_INST_OR;
                                        3'b111: decoded_opcode = OP_INST_AND;
                                    endcase
                                end
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // OP-FP
                                2'b11: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // SYSTEM
                            endcase
                        end

                        3'b101: begin
                            case (instruction[6:5])
                                2'b00: begin // AUIPC
                                    decoded_cluster = CLUSTER_AUIPC;
                                    decoded_opcode  = OP_AUIPC;
                                end
                                2'b01: begin // LUI
                                    decoded_cluster = CLUSTER_LUI;
                                    decoded_opcode  = OP_LUI;
                                end
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end
                                2'b11: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end
                            endcase
                        end

                        3'b110: begin
                            case (instruction[6:5])
                                2'b00: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // OP-IMM-32
                                2'b01: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // OP-32
                                2'b10: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // rv128
                                2'b11: begin decoded_cluster = CLUSTER_INVALID; decoded_opcode = OP_INVALID; end // rv128
                            endcase
                        end
                        default: ;
                    endcase
                end

                // Driving signals based on cluster
                case (decoded_cluster)
                    CLUSTER_INVALID: begin
                        internal_reg_file_read_address_0 <= 5'b00000;
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b0;
                        internal_reg_file_write_address <= 5'b00000;
                        internal_immediate                <= 32'h00000000;
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_LOAD: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate = {{20{instruction[31]}}, instruction[31:20]};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= instruction[14:12];
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b01;
                        internal_mux1_sel                 <= 1'b1;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_STORE: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= instruction[24:20];
                        internal_reg_file_write          <= 1'b0;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= instruction[14:12];
                        internal_datamem_write            <= 1'b1;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b1;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_BRANCH: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= instruction[24:20];
                        internal_reg_file_write          <= 1'b0;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b1;
                        internal_ALU_branch_control       <= instruction[14:12];
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_JALR: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        // VHDL shift_right equivalent with sign-extension
                        internal_immediate = {{20{instruction[31]}}, instruction[31:20]};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b1;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b1;
                        internal_mux0_sel                 <= 2'b10;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_JAL: begin
                        internal_reg_file_read_address_0 <= 5'b00000;
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        // VHDL shift_right equivalent with sign-extension
                        internal_immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b1;
                        internal_mux0_sel                 <= 2'b10;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_OP_IMM: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= instruction[24:20];
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b1;

                        case (decoded_opcode)
                            OP_ADDI, OP_SLTI, OP_SLTIU: begin
                                internal_ALU_operation <= {1'b0, instruction[14:12]};
                                internal_immediate = {{20{instruction[31]}}, instruction[31:20]};
                            end
                            OP_XORI, OP_ORI, OP_ANDI: begin
                                internal_ALU_operation <= {1'b0, instruction[14:12]};
                                internal_immediate     <= {20'b0, instruction[31:20]};
                            end
                            OP_SLLI: begin
                                internal_ALU_operation <= {1'b0, instruction[14:12]};
                                internal_immediate     <= {27'b0, instruction[24:20]};
                            end
                            OP_SRLI, OP_SRAI: begin
                                internal_ALU_operation <= {instruction[30], instruction[14:12]};
                                internal_immediate     <= {27'b0, instruction[24:20]};
                            end
                            default: ;
                        endcase
                        next_state <= STATE_NORMAL;
                    end

                    CLUSTER_OP: begin
                        internal_reg_file_read_address_0 <= instruction[19:15];
                        internal_reg_file_read_address_1 <= instruction[24:20];
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate                <= 32'h00000000;
                        internal_ALU_operation            <= {instruction[30], instruction[14:12]};
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_AUIPC: begin
                        internal_reg_file_read_address_0 <= 5'b00000;
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate                <= {instruction[31:12], 12'b0};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b0;
                        next_state                        <= STATE_NORMAL;
                    end

                    CLUSTER_LUI: begin
                        internal_reg_file_read_address_0 <= 5'b00000;
                        internal_reg_file_read_address_1 <= 5'b00000;
                        internal_reg_file_write          <= 1'b1;
                        internal_reg_file_write_address <= instruction[11:7];
                        internal_immediate                <= {instruction[31:12], 12'b0};
                        internal_ALU_operation            <= 4'b0000;
                        internal_ALU_branch               <= 1'b0;
                        internal_ALU_branch_control       <= 3'b000;
                        internal_JTU_mux_sel              <= 1'b0;
                        internal_data_format              <= 3'b000;
                        internal_datamem_write            <= 1'b0;
                        internal_jump_flag                <= 1'b0;
                        internal_mux0_sel                 <= 2'b00;
                        internal_mux1_sel                 <= 1'b1;
                        next_state                        <= STATE_NORMAL;
                    end

                    default: ;
                endcase
            end
            default: ;
        endcase
    end

    // Wiring Output Ports
    assign reg_file_read_address_0 = internal_reg_file_read_address_0;
    assign reg_file_read_address_1 = internal_reg_file_read_address_1;
    assign reg_file_write          = internal_reg_file_write;
    assign reg_file_write_address  = internal_reg_file_write_address;
    assign immediate               = internal_immediate;
    assign ALU_operation           = internal_ALU_operation;
    assign ALU_branch              = internal_ALU_branch;
    assign ALU_branch_control      = internal_ALU_branch_control;
    assign JTU_mux_sel             = internal_JTU_mux_sel;
    assign data_format             = internal_data_format;
    assign datamem_write           = internal_datamem_write;
    assign jump_flag               = internal_jump_flag;
    assign mux0_sel                = internal_mux0_sel;
    assign mux1_sel                = internal_mux1_sel;

endmodule