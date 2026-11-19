module top_module #(
    parameter AW = 6,
    parameter DW = 8
)(
    input  wire             clk,

    input  wire [AW-1:0]    addr_a,
    input  wire [DW-1:0]    din_a,
    input  wire             we_a,
    output reg  [DW-1:0]    dout_a,

    input  wire [AW-1:0]    addr_b,
    input  wire [DW-1:0]    din_b,
    input  wire             we_b,
    output reg  [DW-1:0]    dout_b
);

    reg [DW-1:0] mem [0:(1<<AW)-1];

    // Port A: independent write and read-old-data, same convention as
    // the Single-Port RAM problem.
    always @(posedge clk) begin
        if (we_a)
            mem[addr_a] <= din_a;
        dout_a <= mem[addr_a];
    end

    // Port B: fully independent of port A's address/data/we.
    always @(posedge clk) begin
        if (we_b)
            mem[addr_b] <= din_b;
        dout_b <= mem[addr_b];
    end

endmodule
