module top_module (
    input  wire src_clk,
    input  wire src_rst,
    input  wire src_pulse,

    input  wire dst_clk,
    input  wire dst_rst,
    output wire dst_pulse
);

    // Source domain: convert the one-shot pulse into a toggle level.
    reg toggle;
    always @(posedge src_clk) begin
        if (src_rst)
            toggle <= 1'b0;
        else if (src_pulse)
            toggle <= ~toggle;
    end

    // Destination domain: 2-flop synchronize the toggle, then edge-detect.
    reg meta, sync, sync_d;
    always @(posedge dst_clk) begin
        if (dst_rst) begin
            meta   <= 1'b0;
            sync   <= 1'b0;
            sync_d <= 1'b0;
        end else begin
            meta   <= toggle;
            sync   <= meta;
            sync_d <= sync;
        end
    end

    assign dst_pulse = sync ^ sync_d;

endmodule
