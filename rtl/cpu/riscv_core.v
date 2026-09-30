module riscv_core (
    input wire clk,
    input wire reset,

    // Instruction memory
    output wire [31:0] imem_addr,
    input wire [31:0] imem_rdata,

    // Data memory
    output wire dmem_we,
    output wire dmem_re,
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    input wire [31:0] dmem_rdata,

    output wire [31:0] debug_pc
);

    reg [31:0] pc;

    wire [31:0] instruction;

    assign instruction = imem_rdata;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire alu_src;
    wire branch;
    wire jump;

    wire [3:0] alu_sel;
    wire [2:0] imm_type;

    riscv_decoder decoder (
        .instruction(instruction),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_sel(alu_sel),
        .imm_type(imm_type)
    );

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    wire [31:0] writeback_data;

    riscv_regfile regfile (
        .clk(clk),
        .reset(reset),

        .rs1_addr(rs1),
        .rs2_addr(rs2),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data),

        .reg_write(reg_write),
        .rd_addr(rd),
        .rd_data(writeback_data)
    );

    reg [31:0] immediate;

    always @(*) begin

        case (imm_type)

            // I-type
            3'b000:
                immediate = {{20{instruction[31]}},
                             instruction[31:20]};

            // S-type
            3'b001:
                immediate = {{20{instruction[31]}},
                             instruction[31:25],
                             instruction[11:7]};

            // B-type
            3'b010:
                immediate = {{19{instruction[31]}},
                             instruction[31],
                             instruction[7],
                             instruction[30:25],
                             instruction[11:8],
                             1'b0};

            // U-type
            3'b011:
                immediate = {instruction[31:12],12'd0};

            // J-type
            3'b100:
                immediate = {{11{instruction[31]}},
                             instruction[31],
                             instruction[19:12],
                             instruction[20],
                             instruction[30:21],
                             1'b0};

            default:
                immediate = 32'd0;

        endcase

    end

    wire [31:0] alu_b;

    assign alu_b =
        alu_src ? immediate : rs2_data;

    wire [31:0] alu_result;
    wire alu_zero;

    riscv_alu alu (
        .a(rs1_data),
        .b(alu_b),
        .alu_sel(alu_sel),
        .result(alu_result),
        .zero(alu_zero)
    );

    assign dmem_we    = mem_write;
    assign dmem_re    = mem_read;
    assign dmem_addr  = alu_result;
    assign dmem_wdata = rs2_data;

    assign writeback_data =
        jump      ? (pc + 32'd4) :
        mem_read  ? dmem_rdata :
        alu_result;

    wire branch_taken;

    assign branch_taken = branch && alu_zero;

    reg [31:0] next_pc;

    always @(*) begin

        next_pc = pc + 32'd4;

        if (branch_taken)
            next_pc = pc + immediate;

        if (jump)
            next_pc = pc + immediate;

    end

    always @(posedge clk) begin

        if (reset)
            pc <= 32'd0;

        else
            pc <= next_pc;

    end

    assign imem_addr = pc;
    assign debug_pc  = pc;

endmodule