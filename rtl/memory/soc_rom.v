module soc_rom #(
    parameter MEM_FILE = "software/program.hex"
)(
    input  wire [31:0] addr,
    output wire [31:0] data
);

    reg [31:0] rom [0:1023];

    integer i;

    initial begin

        for (i = 0; i < 1024; i = i + 1)
            rom[i] = 32'h00000013;

        $readmemh(MEM_FILE, rom);

    end

    assign data = rom[addr[11:2]];

endmodule