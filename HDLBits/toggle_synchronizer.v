module top_module (
    input  wire src_clk,
    input  wire src_rst,
    input  wire src_event,

    input  wire dst_clk,
    input  wire dst_rst,
    output wire dst_toggle
);

    reg src_toggle;
    always @(posedge src_clk) begin
        if (src_rst)
            src_toggle <= 1'b0;
        else if (src_event)
            src_toggle <= ~src_toggle;
    end

    reg meta, sync;
    always @(posedge dst_clk) begin
        if (dst_rst) begin
            meta <= 1'b0;
            sync <= 1'b0;
        end else begin
            meta <= src_toggle;
            sync <= meta;
        end
    end

    assign dst_toggle = sync;

endmodule
