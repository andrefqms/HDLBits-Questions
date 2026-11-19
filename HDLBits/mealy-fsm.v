module top_module (
    input wire clk,
    input wire reset,
    input wire x,
    output wire y
);
    localparam [1:0] s0 = 2'd0;
    localparam [1:0] s1 = 2'd1;
    localparam [1:0] s11 = 2'd2;
    localparam [1:0] s110 = 2'd3;
    reg [1:0] state = 2'd0;
    reg pulse = 1'b0;
    assign y = pulse;
    always @(posedge clk) begin
        pulse <= 1'b0;
        if (reset == 1'b1) begin
            state <= s0;
        end
        else begin
            case (state)
            s0: begin
                if (x == 1'b1) begin
                    state <= s1;
                end
            end
            s1: begin
                if (x == 1'b1) begin
                    state <= s11;
                end
                else begin
                    state <= s0;
                end
            end
            s11: begin
                if (x == 1'b0) begin
                    state <= s110;
                end
            end
            s110: begin
                if (x == 1'b1) begin
                    pulse <= 1'b1;
                    state <= s1;
                end
                else begin
                    state <= s0;
                end
            end
            endcase
        end
    end
endmodule
