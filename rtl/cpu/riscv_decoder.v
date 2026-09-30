module riscv_decoder (
    input  wire [31:0] instruction,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,

    output reg alu_src,
    output reg branch,
    output reg jump,

    output reg [3:0] alu_sel,

    output reg [2:0] imm_type
);

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SRA = 4'b1000;

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    always @(*) begin

        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;

        alu_src   = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;

        alu_sel   = ALU_ADD;
        imm_type  = IMM_I;

        case (opcode)

            // OP-IMM
            7'b0010011: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_I;

                case (funct3)

                    3'b000:
                        alu_sel = ALU_ADD; // ADDI

                    3'b111:
                        alu_sel = ALU_AND; // ANDI

                    3'b110:
                        alu_sel = ALU_OR;  // ORI

                    3'b100:
                        alu_sel = ALU_XOR; // XORI

                    3'b010:
                        alu_sel = ALU_SLT; // SLTI

                    default:
                        alu_sel = ALU_ADD;

                endcase

            end


            // R-type
            7'b0110011: begin

                reg_write = 1'b1;
                alu_src   = 1'b0;

                case ({funct7, funct3})

                    10'b0000000_000:
                        alu_sel = ALU_ADD;

                    10'b0100000_000:
                        alu_sel = ALU_SUB;

                    10'b0000000_111:
                        alu_sel = ALU_AND;

                    10'b0000000_110:
                        alu_sel = ALU_OR;

                    10'b0000000_100:
                        alu_sel = ALU_XOR;

                    10'b0000000_010:
                        alu_sel = ALU_SLT;

                    10'b0000000_001:
                        alu_sel = ALU_SLL;

                    10'b0000000_101:
                        alu_sel = ALU_SRL;

                    10'b0100000_101:
                        alu_sel = ALU_SRA;

                    default:
                        alu_sel = ALU_ADD;

                endcase

            end


            // LOAD
            7'b0000011: begin

                if (funct3 == 3'b010) begin
                    reg_write = 1'b1;
                    mem_read  = 1'b1;
                    alu_src   = 1'b1;
                    alu_sel   = ALU_ADD;
                    imm_type  = IMM_I;
                end

            end


            // STORE
            7'b0100011: begin

                if (funct3 == 3'b010) begin
                    mem_write = 1'b1;
                    alu_src   = 1'b1;
                    alu_sel   = ALU_ADD;
                    imm_type  = IMM_S;
                end

            end


            // BEQ
            7'b1100011: begin

                if (funct3 == 3'b000) begin
                    branch   = 1'b1;
                    alu_src  = 1'b0;
                    alu_sel  = ALU_SUB;
                    imm_type = IMM_B;
                end

            end


            // JAL
            7'b1101111: begin

                reg_write = 1'b1;
                jump      = 1'b1;
                imm_type  = IMM_J;

            end


            // LUI
            7'b0110111: begin

                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_sel   = ALU_ADD;
                imm_type  = IMM_U;

            end


            default: begin

                reg_write = 1'b0;

            end

        endcase

    end

endmodule