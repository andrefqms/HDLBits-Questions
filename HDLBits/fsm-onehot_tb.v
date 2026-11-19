`timescale 1ns/1ps
module fsm_onehot_tb;
    reg in;
    reg [9:0] state;
    wire [9:0] next_state;
    wire out1, out2;

    top_module uut(.in(in), .state(state), .next_state(next_state),
                   .out1(out1), .out2(out2));

    integer i;
    initial begin
        $display("=== fsm-onehot Testbench ===");
        for (i = 0; i < 10; i = i + 1) begin
            state = 10'b1 << i;
            in = 0; #10;
            $display("state[%0d]=1 in=0 -> next=%b out1=%b out2=%b",
                     i, next_state, out1, out2);
            in = 1; #10;
            $display("state[%0d]=1 in=1 -> next=%b out1=%b out2=%b",
                     i, next_state, out1, out2);
        end
        $finish;
    end
endmodule