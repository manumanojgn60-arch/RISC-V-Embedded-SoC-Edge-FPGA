module riscv_regfile (
    input wire clk,
    input wire reset,

    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,

    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,

    input wire reg_write,
    input wire [4:0] rd_addr,
    input wire [31:0] rd_data
);

    reg [31:0] registers [0:31];

    integer i;

    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;

        end

        else begin

            if (reg_write && (rd_addr != 5'd0))
                registers[rd_addr] <= rd_data;

        end

    end

    assign rs1_data =
        (rs1_addr == 5'd0) ?
        32'd0 :
        registers[rs1_addr];

    assign rs2_data =
        (rs2_addr == 5'd0) ?
        32'd0 :
        registers[rs2_addr];

endmodule