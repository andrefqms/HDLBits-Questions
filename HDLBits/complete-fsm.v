/*
Detect 101, support overlapping 
matches, and expose the current encoded 
FSM state. Output detected is high in the match state. Reset returns to state s0.
*/

module top_module (
    input wire clk,
    input wire reset,
    input wire x,
    output reg [1:0] state_out,
    output wire detected
);
    localparam [1:0] s0 = 2'd0;
    localparam [1:0] s1 = 2'd1;
    localparam [1:0] s10 = 2'd2;
    localparam [1:0] hit = 2'd3;
    reg [1:0] state = 2'd0;
    assign detected = (state == hit) ? 1'b1 : 1'b0;
    always @(posedge clk) begin
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
                if (x == 1'b0) begin
                    state <= s10;
                end
            end
            s10: begin
                if (x == 1'b1) begin
                    state <= hit;
                end
                else begin
                    state <= s0;
                end
            end
            hit: begin
                if (x == 1'b1) begin
                    state <= s1;
                end
                else begin
                    state <= s10;
                end
            end
            endcase
        end
    end
    always @(*) begin
        case (state)
            s0: state_out = 2'b00;
            s1: state_out = 2'b01;
            s10: state_out = 2'b10;
            hit: state_out = 2'b11;
        endcase
    end
endmodule
