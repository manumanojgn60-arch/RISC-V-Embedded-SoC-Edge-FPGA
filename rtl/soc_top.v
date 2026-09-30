module soc_top (
    input wire clk,
    input wire reset,

    output wire [7:0] gpio,
    output wire uart_tx,
    output wire timer_tick,
    output wire pwm_out,

    output wire [31:0] debug_pc
);

    // CPU instruction interface
    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    // CPU data interface
    wire dmem_we;
    wire dmem_re;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [31:0] dmem_rdata;


    // ROM
    wire [31:0] rom_rdata;

    soc_rom rom (
        .addr(imem_addr),
        .data(rom_rdata)
    );


    // RAM
    wire ram_we;
    wire ram_re;
    wire [31:0] ram_addr;
    wire [31:0] ram_wdata;
    wire [31:0] ram_rdata;

    soc_ram ram (
        .clk(clk),
        .reset(reset),

        .write_en(ram_we),
        .read_en(ram_re),

        .addr(ram_addr),
        .write_data(ram_wdata),

        .read_data(ram_rdata)
    );


    // GPIO
    wire gpio_we;
    wire gpio_re;
    wire [31:0] gpio_rdata;

    gpio gpio_inst (
        .clk(clk),
        .reset(reset),

        .write_en(gpio_we),
        .read_en(gpio_re),

        .write_data(dmem_wdata),

        .read_data(gpio_rdata),
        .gpio_out(gpio)
    );


    // UART
    wire uart_we;
    wire uart_busy;

    uart_tx #(
        .CLK_DIV(868)
    ) uart (
        .clk(clk),
        .reset(reset),

        .tx_start(uart_we),
        .tx_data(dmem_wdata[7:0]),

        .tx(uart_tx),
        .busy(uart_busy)
    );


    // Timer
    wire timer_we;
    wire [31:0] timer_rdata;

    timer timer_inst (
        .clk(clk),
        .reset(reset),

        .write_en(timer_we),
        .write_data(dmem_wdata),

        .read_data(timer_rdata),
        .tick(timer_tick)
    );


    // PWM
    wire pwm_we;
    wire [31:0] pwm_rdata;

    pwm pwm_inst (
        .clk(clk),
        .reset(reset),

        .write_en(pwm_we),
        .write_data(dmem_wdata),

        .read_data(pwm_rdata),
        .pwm_out(pwm_out)
    );


    // MAC Accelerator
    wire mac_we;
    wire mac_re;

    wire [31:0] mac_addr;
    wire [31:0] mac_wdata;
    wire [31:0] mac_rdata;

    mac_accelerator mac (
        .clk(clk),
        .reset(reset),

        .write_en(mac_we),
        .read_en(mac_re),

        .address(mac_addr),
        .write_data(mac_wdata),

        .read_data(mac_rdata),
        .done()
    );


    // BUS
    soc_bus bus (
        .clk(clk),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_rdata(dmem_rdata),

        .rom_rdata(rom_rdata),

        .ram_we(ram_we),
        .ram_re(ram_re),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_rdata(ram_rdata),

        .gpio_we(gpio_we),
        .gpio_re(gpio_re),
        .gpio_rdata(gpio_rdata),

        .uart_we(uart_we),
        .uart_busy(uart_busy),

        .timer_we(timer_we),
        .timer_rdata(timer_rdata),

        .pwm_we(pwm_we),
        .pwm_rdata(pwm_rdata),

        .mac_we(mac_we),
        .mac_re(mac_re),
        .mac_addr(mac_addr),
        .mac_wdata(mac_wdata),
        .mac_rdata(mac_rdata)
    );


    // CPU
    riscv_core cpu (
        .clk(clk),
        .reset(reset),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_rdata(dmem_rdata),

        .debug_pc(debug_pc)
    );

endmodule