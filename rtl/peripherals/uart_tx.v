module uart_tx #(
    parameter CLK_DIV = 868
)(
    input wire clk,
    input wire reset,

    input wire tx_start,
    input wire [7:0] tx_data,

    output reg tx,
    output reg busy
);

    reg [15:0] clk_count;
    reg [3:0] bit_count;
    reg [9:0] shift_reg;

    always @(posedge clk) begin

        if (reset) begin

            tx        <= 1'b1;
            busy      <= 1'b0;
            clk_count <= 16'd0;
            bit_count <= 4'd0;
            shift_reg <= 10'b1111111111;

        end

        else begin

            if (!busy) begin

                tx <= 1'b1;

                if (tx_start) begin

                    shift_reg <= {
                        1'b1,
                        tx_data,
                        1'b0
                    };

                    busy      <= 1'b1;
                    clk_count <= 16'd0;
                    bit_count <= 4'd0;
                    tx        <= 1'b0;

                end

            end

            else begin

                if (clk_count >= CLK_DIV - 1) begin

                    clk_count <= 16'd0;

                    shift_reg <= {
                        1'b1,
                        shift_reg[9:1]
                    };

                    bit_count <= bit_count + 1'b1;

                    tx <= shift_reg[1];

                    if (bit_count == 4'd9) begin

                        busy <= 1'b0;
                        tx   <= 1'b1;

                    end

                end

                else begin

                    clk_count <= clk_count + 1'b1;

                end

            end

        end

    end

endmodule