module top_module #(
    parameter WIDTH = 8,
    parameter DEPTH = 16   // must be a power of 2
)(
    input  wire             wr_clk,
    input  wire             wr_rst,
    input  wire             wr_en,
    input  wire [WIDTH-1:0] wr_data,
    output wire             full,

    input  wire             rd_clk,
    input  wire             rd_rst,
    input  wire             rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire             empty
);

    localparam AW = $clog2(DEPTH);

    // Modeled behaviorally as a simple dual-clock array; on a real ASIC/FPGA
    // target this maps onto a dual-port memory macro (one write port clocked
    // by wr_clk, one read port clocked by rd_clk).
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // ---------------- Write domain ----------------
    reg  [AW:0] wbin, wgray;
    reg         full_r;

    wire        wclken     = wr_en & ~full_r;
    wire [AW:0] wbin_next  = wbin + wclken;
    wire [AW:0] wgray_next = (wbin_next >> 1) ^ wbin_next;

    reg  [AW:0] rq1_rgray, rq2_rgray;   // 2-flop sync of the read pointer into wr_clk

    wire full_next = (wgray_next == {~rq2_rgray[AW:AW-1], rq2_rgray[AW-2:0]});

    always @(posedge wr_clk) begin
        if (wr_rst) begin
            wbin   <= {(AW+1){1'b0}};
            wgray  <= {(AW+1){1'b0}};
            full_r <= 1'b0;
        end else begin
            wbin   <= wbin_next;
            wgray  <= wgray_next;
            full_r <= full_next;
        end
    end

    always @(posedge wr_clk) begin
        if (wclken)
            mem[wbin[AW-1:0]] <= wr_data;
    end

    always @(posedge wr_clk) begin
        if (wr_rst) begin
            rq1_rgray <= {(AW+1){1'b0}};
            rq2_rgray <= {(AW+1){1'b0}};
        end else begin
            rq1_rgray <= rgray;   // rgray driven from the read domain below
            rq2_rgray <= rq1_rgray;
        end
    end

    assign full = full_r;

    // ---------------- Read domain ----------------
    reg  [AW:0] rbin, rgray;
    reg         empty_r;

    wire        rclken     = rd_en & ~empty_r;
    wire [AW:0] rbin_next  = rbin + rclken;
    wire [AW:0] rgray_next = (rbin_next >> 1) ^ rbin_next;

    reg  [AW:0] wq1_wgray, wq2_wgray;   // 2-flop sync of the write pointer into rd_clk

    wire empty_next = (rgray_next == wq2_wgray);

    always @(posedge rd_clk) begin
        if (rd_rst) begin
            rbin    <= {(AW+1){1'b0}};
            rgray   <= {(AW+1){1'b0}};
            empty_r <= 1'b1;
        end else begin
            rbin    <= rbin_next;
            rgray   <= rgray_next;
            empty_r <= empty_next;
        end
    end

    always @(posedge rd_clk) begin
        if (rd_rst) begin
            wq1_wgray <= {(AW+1){1'b0}};
            wq2_wgray <= {(AW+1){1'b0}};
        end else begin
            wq1_wgray <= wgray;
            wq2_wgray <= wq1_wgray;
        end
    end

    assign empty   = empty_r;
    assign rd_data = mem[rbin[AW-1:0]];

endmodule
