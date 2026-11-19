module top_module (
    input clk,
    input resetn,
    input [3:1] r,
    output reg [3:1] g
);
    localparam IDLE=2'd0, G1=2'd1, G2=2'd2, G3=2'd3;
    reg [1:0] state;
    reg [1:0] next_state;
    always @(*) begin
        next_state=state;
        case (state)
            IDLE: if (r[1]) next_state=G1; else if (r[2]) next_state=G2; else if (r[3]) next_state=G3;
            G1: if (!r[1]) next_state=IDLE;
            G2: if (!r[2]) next_state=IDLE;
            G3: if (!r[3]) next_state=IDLE;
            default: next_state=IDLE;
        endcase
    end
    always @(posedge clk) begin
        if (!resetn) state<=IDLE;
        else state<=next_state;
    end
    always @(*) begin
        g=3'b000;
        case (state)
            G1: g[1]=1'b1;
            G2: g[2]=1'b1;
            G3: g[3]=1'b1;
        endcase
    end
endmodule
