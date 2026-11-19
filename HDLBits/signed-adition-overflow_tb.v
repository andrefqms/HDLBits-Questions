`timescale 1ns/1ps
module signed_adition_overflow_tb;
    reg  [7:0] a, b;
    wire [7:0] s;
    wire overflow;

    top_module uut(.a(a), .b(b), .s(s), .overflow(overflow));

    task check(input signed [7:0] ta, input signed [7:0] tb);
        begin
            a = ta; b = tb; #10;
            $display("a=%4d b=%4d  s=%4d  overflow=%b",
                     $signed(a), $signed(b), $signed(s), overflow);
        end
    endtask

    initial begin
        $display("=== Signed Addition Overflow Testbench ===");
        check( 10,  20);   // no overflow
        check(127,   1);   // overflow (+)
        check(128, 255);   // (-128) + (-1) overflow
        check(246,  20);   // (-10) + 20 = 10, no overflow
        check(206, 206);   // (-50) + (-50) = -100, no overflow
        check(100, 100);   // 200 -> -56 overflow
        check(  0,   0);   // zero
        check( 50, 100);   // 150 -> overflow
        check(255,   1);   // (-1) + 1 = 0, no overflow
        $finish;
    end
endmodule