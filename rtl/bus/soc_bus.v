module soc_bus (
    input wire clk,
    input wire reset,

    // Instruction interface
    input wire [31:0] imem_addr,
    output wire [31:0] imem_rdata,

    // CPU data interface
    input wire dmem_we,
    input wire dmem_re,
    input wire [31:0] dmem_addr,
    input wire [31:0] dmem_wdata,
    output reg [31:0] dmem_rdata,

    // ROM
    input wire [31:0] rom_rdata,

    // RAM
    output wire ram_we,
    output wire ram_re,
    output wire [31:0] ram_addr,
    output wire [31:0] ram_wdata,
    input wire [31:0] ram_rdata,

    // GPIO
    output wire gpio_we,
    output wire gpio_re,
    input wire [31:0] gpio_rdata,

    // UART
    output wire uart_we,
    input wire uart_busy,

    // Timer
    output wire timer_we,
    input wire [31:0] timer_rdata,

    // PWM
    output wire pwm_we,
    input wire [31:0] pwm_rdata,

    // MAC
    output wire mac_we,
    output wire mac_re,
    output wire [31:0] mac_addr,
    output wire [31:0] mac_wdata,
    input wire [31:0] mac_rdata
);

    // Instruction memory
    assign imem_rdata = rom_rdata;


    // RAM
    assign ram_we =
        dmem_we &&
        (dmem_addr >= 32'h00001000) &&
        (dmem_addr <  32'h00002000);

    assign ram_re =
        dmem_re &&
        (dmem_addr >= 32'h00001000) &&
        (dmem_addr <  32'h00002000);

    assign ram_addr =
        dmem_addr - 32'h00001000;

    assign ram_wdata = dmem_wdata;


    // GPIO
    assign gpio_we =
        dmem_we &&
        (dmem_addr == 32'h00002000);

    assign gpio_re =
        dmem_re &&
        (dmem_addr == 32'h00002000);


    // UART
    assign uart_we =
        dmem_we &&
        (dmem_addr == 32'h00003000);


    // Timer
    assign timer_we =
        dmem_we &&
        (dmem_addr == 32'h00004000);


    // PWM
    assign pwm_we =
        dmem_we &&
        (dmem_addr == 32'h00005000);


    // MAC
    assign mac_we =
        dmem_we &&
        (dmem_addr >= 32'h00006000) &&
        (dmem_addr <= 32'h00006010);

    assign mac_re =
        dmem_re &&
        (dmem_addr >= 32'h00006000) &&
        (dmem_addr <= 32'h00006010);

    assign mac_addr  = dmem_addr;
    assign mac_wdata = dmem_wdata;


    // Read multiplexer
    always @(*) begin

        dmem_rdata = 32'd0;

        if (dmem_re) begin

            if ((dmem_addr >= 32'h00001000) &&
                (dmem_addr < 32'h00002000))

                dmem_rdata = ram_rdata;

            else if (dmem_addr == 32'h00002000)

                dmem_rdata = gpio_rdata;

            else if (dmem_addr == 32'h00004000)

                dmem_rdata = timer_rdata;

            else if (dmem_addr == 32'h00005000)

                dmem_rdata = pwm_rdata;

            else if ((dmem_addr >= 32'h00006000) &&
                     (dmem_addr <= 32'h00006010))

                dmem_rdata = mac_rdata;

            else

                dmem_rdata = 32'd0;

        end

    end

endmodule