`timescale 1ns/1ps

module soc_tb;

    reg clk;
    reg reset;

    wire [7:0] gpio;
    wire uart_tx;
    wire timer_tick;
    wire pwm_out;

    wire [31:0] debug_pc;


    soc_top dut (
        .clk(clk),
        .reset(reset),

        .gpio(gpio),
        .uart_tx(uart_tx),

        .timer_tick(timer_tick),
        .pwm_out(pwm_out),

        .debug_pc(debug_pc)
    );


    // Clock
    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // Reset
    initial begin

        reset = 1'b1;

        #100;

        reset = 1'b0;

    end


    // Debug
    always @(posedge clk) begin

        if (!reset) begin

            $display(
                "TIME=%0t | PC=%h | INST=%h | WE=%b | ADDR=%h | WDATA=%h | GPIO=%h | TIMER=%b",
                $time,
                debug_pc,
                dut.cpu.instruction,
                dut.cpu.dmem_we,
                dut.cpu.dmem_addr,
                dut.cpu.dmem_wdata,
                gpio,
                timer_tick
            );

        end

    end


    // Final verification
    initial begin

        #2000;

        $display("");
        $display("==========================================");
        $display("      RISC-V EDGE SoC VERIFICATION");
        $display("==========================================");

        $display("x1 = %0d",
                 dut.cpu.regfile.registers[1]);

        $display("x2 = %0d",
                 dut.cpu.regfile.registers[2]);

        $display("x3 = %0d",
                 dut.cpu.regfile.registers[3]);

        $display("MAC Result = %0d",
                 dut.mac.result);

        $display("GPIO = %h",
                 gpio);

        if (dut.mac.result == 32'd205)
            $display("MAC RESULT: PASS");
        else
            $display("MAC RESULT: FAIL");

        if (gpio == 8'hCD)
            $display("GPIO OUTPUT: PASS");
        else
            $display("GPIO OUTPUT: FAIL");

        $display("==========================================");
        $display("");

    end


    initial begin

        $dumpfile("soc.vcd");
        $dumpvars(0, soc_tb);

    end


    initial begin

        #5000;

        $display("SIMULATION COMPLETE");

        $finish;

    end

endmodule