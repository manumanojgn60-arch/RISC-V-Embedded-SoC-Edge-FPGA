`timescale 1ns/1ps

module mac_accelerator_tb;

    reg clk;
    reg reset;

    reg write_en;
    reg read_en;

    reg [31:0] address;
    reg [31:0] write_data;

    wire [31:0] read_data;
    wire done;

    mac_accelerator dut (
        .clk(clk),
        .reset(reset),

        .write_en(write_en),
        .read_en(read_en),

        .address(address),
        .write_data(write_data),

        .read_data(read_data),
        .done(done)
    );


    // Clock
    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // Test
    initial begin

        reset     = 1'b1;
        write_en  = 1'b0;
        read_en   = 1'b0;
        address   = 32'd0;
        write_data = 32'd0;

        #20;

        reset = 1'b0;

        // A = 10
        @(posedge clk);
        #1;

        write_en   = 1'b1;
        address    = 32'h00006000;
        write_data = 32'd10;

        @(posedge clk);
        #1;

        // B = 20
        address    = 32'h00006004;
        write_data = 32'd20;

        @(posedge clk);
        #1;

        // C = 5
        address    = 32'h00006008;
        write_data = 32'd5;

        @(posedge clk);
        #1;

        // Start
        address    = 32'h00006010;
        write_data = 32'd1;

        @(posedge clk);
        #1;

        write_en = 1'b0;

        // Read result
        read_en = 1'b1;
        address = 32'h0000600C;

        #10;

        $display("");
        $display("======================================");
        $display("       MAC ACCELERATOR TEST");
        $display("======================================");

        $display("A      = %0d", 10);
        $display("B      = %0d", 20);
        $display("C      = %0d", 5);

        $display("RESULT = %0d", read_data);

        if (read_data == 32'd205)
            $display("MAC TEST: PASS");
        else
            $display("MAC TEST: FAIL");

        $display("======================================");
        $display("");

        $finish;

    end


    initial begin

        $dumpfile("mac_accelerator.vcd");
        $dumpvars(0, mac_accelerator_tb);

    end

endmodule