module top_module (
    input clk,
    input d,
    output q
);
    reg [1:0] state;
    
    always @(posedge clk) begin
        state[0] <= d;
    end
    
    always @(negedge clk) begin
        state[1] <= d;
    end
    
    assign q = (clk)? state[0]:state[1];

endmodule
