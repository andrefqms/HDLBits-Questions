module top_module #(
    parameter WIDTH = 8,
    parameter DEPTH = 16   // must be a power of 2
)(
    input  wire             clk,
    input  wire             rst,      // synchronous, active-high
    input  wire             wr_en,
    input  wire [WIDTH-1:0] wr_data,
    input  wire             rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire             full,
    output wire             empty
);

    localparam AW = $clog2(DEPTH);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [AW:0]      wr_ptr, rd_ptr;   // one extra MSB bit beyond the address width

    wire [AW-1:0] wr_addr = wr_ptr[AW-1:0];
    wire [AW-1:0] rd_addr = rd_ptr[AW-1:0];

    // Equal pointers (including the extra bit) => empty.
    // Equal address bits but different extra bit => wrapped all the way around => full.
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[AW] != rd_ptr[AW]) && (wr_ptr[AW-1:0] == rd_ptr[AW-1:0]);

    wire do_write = wr_en && !full;
    wire do_read  = rd_en && !empty;

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= {(AW+1){1'b0}};
            rd_ptr <= {(AW+1){1'b0}};
        end else begin
            if (do_write) begin
                mem[wr_addr] <= wr_data;
                wr_ptr       <= wr_ptr + 1'b1;
            end
            if (do_read)
                rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Fall-through (first-word-fall-through) read: rd_data always reflects
    // the current front-of-queue entry combinationally; rd_en pops it.
    assign rd_data = mem[rd_addr];

endmodule
