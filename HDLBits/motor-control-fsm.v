module top_module (
    input wire clk,
    input wire resetn,
    input wire x,
    input wire y,
    output wire f,
    output wire g
);
    localparam [3:0] A = 4'd0;
    localparam [3:0] pulse_f = 4'd1;
    localparam [3:0] search = 4'd2;
    localparam [3:0] find1 = 4'd3;
    localparam [3:0] find10 = 4'd4;
    localparam [3:0] check_y1 = 4'd5;
    localparam [3:0] check_y2 = 4'd6;
    localparam [3:0] done_high = 4'd7;
    localparam [3:0] done_low = 4'd8;
    reg [3:0] state = 4'd0;
    assign f = (state == pulse_f) ? 1'b1 : 1'b0;
    assign g = (state == check_y1 | state == check_y2 | state == done_high) ? 1'b1 : 1'b0;
    always @(posedge clk) begin
        if (resetn == 1'b0) begin
            state <= A;
        end
        else begin
            case (state)
            A: begin
                state <= pulse_f;
            end
            pulse_f: begin
                state <= find1;
            end
            find1: begin
                if (x == 1'b1) begin
                    state <= find10;
                end
            end
            find10: begin
                if (x == 1'b0) begin
                    state <= find101;
                end
                else begin
                    state <= find10;
                end
            end
            find101: begin
                if (x == 1'b1) begin
                    state <= check_y1;
                end
                else begin
                    state <= find1;
                end
            end
            check_y1: begin
                if (y == 1'b1) begin
                    state <= done_high;
                end
                else begin
                    state <= check_y2;
                end
            end
            check_y2: begin
                if (y == 1'b1) begin
                    state <= done_high;
                end
                else begin
                    state <= done_low;
                end
            end
            done_high: begin
                state <= done_high;
            end
            done_low: begin
                state <= done_low;
            end
            endcase
        end
    end
endmodule
