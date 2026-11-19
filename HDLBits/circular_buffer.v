module top_module #(
    parameter WIDTH = 8,
    parameter DEPTH = 8   // must be a power of 2
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             wr_en,
    input  wire [WIDTH-1:0] wr_data,
    input  wire             rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire             full,
    output wire             empty,
    output wire             overwrite
);

    localparam AW = $clog2(DEPTH);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [AW:0]      wr_ptr, rd_ptr;

    wire [AW-1:0] wr_addr = wr_ptr[AW-1:0];
    wire [AW-1:0] rd_addr = rd_ptr[AW-1:0];

    assign empty     = (wr_ptr == rd_ptr);
    assign full      = (wr_ptr[AW] != rd_ptr[AW]) && (wr_ptr[AW-1:0] == rd_ptr[AW-1:0]);
    assign overwrite = wr_en && full;

    // A normal read pops one entry; an overwrite (write while full) also
    // silently drops the oldest entry. If both happen in the same cycle,
    // the consumer's read *is* the entry being evicted, so rd_ptr still
    // only advances once.
    wire do_read_advance = (rd_en && !empty) || overwrite;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= {(AW+1){1'b0}};
            rd_ptr <= {(AW+1){1'b0}};
        end else begin
            if (wr_en) begin           // writes are ALWAYS accepted, even when full
                mem[wr_addr] <= wr_data;
                wr_ptr       <= wr_ptr + 1'b1;
            end
            if (do_read_advance)
                rd_ptr <= rd_ptr + 1'b1;
        end
    end

    assign rd_data = mem[rd_addr];

endmodule
