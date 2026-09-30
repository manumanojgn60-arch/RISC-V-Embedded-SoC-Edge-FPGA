module soc_ram (
    input wire clk,
    input wire reset,

    input wire write_en,
    input wire read_en,

    input wire [31:0] addr,
    input wire [31:0] write_data,

    output wire [31:0] read_data
);

    reg [31:0] ram [0:1023];

    integer i;

    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < 1024; i = i + 1)
                ram[i] <= 32'd0;

        end

        else if (write_en) begin

            ram[addr[11:2]] <= write_data;

        end

    end

    assign read_data =
        read_en ? ram[addr[11:2]] : 32'd0;

endmodule