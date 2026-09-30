module gpio (
    input wire clk,
    input wire reset,

    input wire write_en,
    input wire read_en,

    input wire [31:0] write_data,

    output wire [31:0] read_data,
    output wire [7:0] gpio_out
);

    reg [7:0] gpio_reg;

    always @(posedge clk) begin

        if (reset)
            gpio_reg <= 8'h00;

        else if (write_en)
            gpio_reg <= write_data[7:0];

    end

    assign gpio_out = gpio_reg;

    assign read_data =
        read_en ? {24'd0, gpio_reg} : 32'd0;

endmodule