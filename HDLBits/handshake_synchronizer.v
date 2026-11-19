module top_module #(
    parameter WIDTH = 16
)(
    input  wire             src_clk,
    input  wire             src_rst,
    input  wire             src_valid,
    input  wire [WIDTH-1:0] src_data,
    output wire             src_ready,

    input  wire             dst_clk,
    input  wire             dst_rst,
    output wire             dst_valid,
    output wire [WIDTH-1:0] dst_data
);

    // ---------------- Source domain ----------------
    localparam S_IDLE = 2'd0, S_WAIT_ACK_HI = 2'd1, S_WAIT_ACK_LO = 2'd2;

    reg [1:0]       src_state;
    reg             req;
    reg [WIDTH-1:0] data_hold;

    wire ack;   // driven by the destination domain, below

    reg ack_meta, ack_sync;
    always @(posedge src_clk) begin
        if (src_rst) begin
            ack_meta <= 1'b0;
            ack_sync <= 1'b0;
        end else begin
            ack_meta <= ack;
            ack_sync <= ack_meta;
        end
    end

    assign src_ready = (src_state == S_IDLE);

    always @(posedge src_clk) begin
        if (src_rst) begin
            src_state <= S_IDLE;
            req       <= 1'b0;
            data_hold <= {WIDTH{1'b0}};
        end else begin
            case (src_state)
                S_IDLE: begin
                    if (src_valid) begin
                        data_hold <= src_data;
                        req       <= 1'b1;
                        src_state <= S_WAIT_ACK_HI;
                    end
                end
                S_WAIT_ACK_HI: begin
                    if (ack_sync) begin
                        req       <= 1'b0;
                        src_state <= S_WAIT_ACK_LO;
                    end
                end
                S_WAIT_ACK_LO: begin
                    if (!ack_sync)
                        src_state <= S_IDLE;
                end
                default: src_state <= S_IDLE;
            endcase
        end
    end

    // ---------------- Destination domain ----------------
    localparam D_IDLE = 1'b0, D_WAIT_REQ_LO = 1'b1;

    reg             dst_state;
    reg             ack_r;
    reg [WIDTH-1:0] dst_data_r;
    reg             dst_valid_r;

    reg req_meta, req_sync;
    always @(posedge dst_clk) begin
        if (dst_rst) begin
            req_meta <= 1'b0;
            req_sync <= 1'b0;
        end else begin
            req_meta <= req;
            req_sync <= req_meta;
        end
    end

    always @(posedge dst_clk) begin
        if (dst_rst) begin
            dst_state   <= D_IDLE;
            ack_r       <= 1'b0;
            dst_data_r  <= {WIDTH{1'b0}};
            dst_valid_r <= 1'b0;
        end else begin
            dst_valid_r <= 1'b0;
            case (dst_state)
                D_IDLE: begin
                    if (req_sync) begin
                        // data_hold has been stable since well before req_sync rose,
                        // so it is safe to sample directly (bundled-data CDC).
                        dst_data_r  <= data_hold;
                        dst_valid_r <= 1'b1;
                        ack_r       <= 1'b1;
                        dst_state   <= D_WAIT_REQ_LO;
                    end
                end
                D_WAIT_REQ_LO: begin
                    if (!req_sync) begin
                        ack_r     <= 1'b0;
                        dst_state <= D_IDLE;
                    end
                end
                default: dst_state <= D_IDLE;
            endcase
        end
    end

    assign ack       = ack_r;
    assign dst_valid = dst_valid_r;
    assign dst_data  = dst_data_r;

endmodule
