module top_module (
    input wire clk,
    input wire reset,
    input wire x,
    output wire y
);
    localparam [1:0] idle = 2'd0;
    localparam [1:0] one_seen = 2'd1;
    localparam [1:0] two_seen = 2'd2;
    reg [1:0] state = 2'd0;
    assign y = (state == two_seen) ? 1'b1 : 1'b0;
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            state <= idle;
        end
        else begin
            case (state)
            idle: begin
                if (x == 1'b1) begin
                    state <= one_seen;
                end
            end
            one_seen: begin
                if (x == 1'b1) begin
                    state <= two_seen;
                end
                else begin
                    state <= idle;
                end
            end
            two_seen: begin
                if (x == 1'b0) begin
                    state <= idle;
                end
            end
            endcase
        end
    end
endmodule
