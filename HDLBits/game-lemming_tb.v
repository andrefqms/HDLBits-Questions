`timescale 1ns/1ps
module game_lemming_tb;
    reg clk, areset, bump_left, bump_right;
    wire walk_left, walk_right;

    top_module uut(.clk(clk), .areset(areset),
                   .bump_left(bump_left), .bump_right(bump_right),
                   .walk_left(walk_left), .walk_right(walk_right));

    always #5 clk = ~clk;

    initial begin
        $display("=== game-lemming Testbench ===");
        clk = 0; areset = 1; bump_left = 0; bump_right = 0;
        #7 areset = 0;
        @(posedge clk);
        $display("After reset: walk_left=%b walk_right=%b (expect LEFT=10)", walk_left, walk_right);

        // Bump left while LEFT -> RIGHT
        bump_left = 1; @(posedge clk); @(posedge clk);
        bump_left = 0; @(posedge clk);
        $display("After bump_left: walk_left=%b walk_right=%b (expect RIGHT=01)", walk_left, walk_right);

        // Bump right while RIGHT -> LEFT
        bump_right = 1; @(posedge clk); @(posedge clk);
        bump_right = 0; @(posedge clk);
        $display("After bump_right: walk_left=%b walk_right=%b (expect LEFT=10)", walk_left, walk_right);

        // Both bumps in LEFT -> RIGHT (bump_left priority in LEFT)
        bump_left = 1; bump_right = 1;
        @(posedge clk); @(posedge clk);
        bump_left = 0; bump_right = 0; @(posedge clk);
        $display("After both bumps: walk_left=%b walk_right=%b", walk_left, walk_right);

        $finish;
    end
endmodule