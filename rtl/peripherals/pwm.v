module pwm (
    input wire clk,
    input wire reset,

    input wire write_en,
    input wire [31:0] write_data,

    output wire [31:0] read_data,
    output wire pwm_out
);

    reg [7:0] duty_cycle;
    reg [7:0] counter;

    always @(posedge clk) begin

        if (reset) begin

            duty_cycle <= 8'd0;
            counter    <= 8'd0;

        end

        else begin

            counter <= counter + 1'b1;

            if (write_en)
                duty_cycle <= write_data[7:0];

        end

    end

    assign pwm_out =
        (counter < duty_cycle);

    assign read_data =
        {24'd0, duty_cycle};

endmodule