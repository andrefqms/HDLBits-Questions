module top_module #(
    parameter AW = 6,
    parameter DW = 8
)(
    input  wire             clk,
    input  wire [AW-1:0]    addr,
    input  wire [DW-1:0]    din,
    input  wire             we,
    output reg  [DW-1:0]    dout
);

    reg [DW-1:0] mem [0:(1<<AW)-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        // Non-blocking assignment reads mem[addr] BEFORE this cycle's write
        // takes effect, giving the standard "read-old-data" RAM behavior.
        dout <= mem[addr];
    end

endmodule
