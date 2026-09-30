module mac_accelerator (
    input  wire        clk,
    input  wire        reset,

    input  wire        write_en,
    input  wire        read_en,

    input  wire [31:0] address,
    input  wire [31:0] write_data,

    output reg  [31:0] read_data,
    output reg         done
);

    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [31:0] operand_c;
    reg [31:0] result;

    always @(posedge clk) begin

        if (reset) begin
            operand_a <= 32'd0;
            operand_b <= 32'd0;
            operand_c <= 32'd0;
            result    <= 32'd0;
            done      <= 1'b0;
        end

        else begin

            done <= 1'b0;

            if (write_en) begin

                case (address)

                    32'h0000_6000:
                        operand_a <= write_data;

                    32'h0000_6004:
                        operand_b <= write_data;

                    32'h0000_6008:
                        operand_c <= write_data;

                    32'h0000_6010: begin

                        if (write_data[0]) begin
                            result <= (operand_a * operand_b)
                                      + operand_c;

                            done <= 1'b1;
                        end

                    end

                    default:
                        begin
                        end

                endcase

            end

        end

    end


    always @(*) begin

        read_data = 32'd0;

        if (read_en) begin

            case (address)

                32'h0000_6000:
                    read_data = operand_a;

                32'h0000_6004:
                    read_data = operand_b;

                32'h0000_6008:
                    read_data = operand_c;

                32'h0000_600C:
                    read_data = result;

                32'h0000_6010:
                    read_data = {31'd0, done};

                default:
                    read_data = 32'd0;

            endcase

        end

    end

endmodule