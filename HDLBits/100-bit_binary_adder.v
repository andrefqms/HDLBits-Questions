module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );

    // 1. O fio de carry precisa ter 101 bits (de c[0] até c[100])
    wire [100:0] c; 
    
    // 2. Conecta o cin global na entrada do primeiro somador
    assign c[0] = cin;
    
    // 3. Conecta o carry do último somador na saída global
    assign cout = c[100];

    genvar i;
    generate
        // 4. O laço deve ir até 100 para criar todos os bits
        for (i = 0; i < 100; i = i + 1) begin : cadeia_somadores
            add1 fa (
                .x(a[i]), 
                .y(b[i]), 
                .cin(c[i]), 
                .sum(sum[i]), 
                .cout(c[i+1])
            );
        end
    endgenerate
    
endmodule

module add1 (input x, input y, input cin, output sum, output cout);
    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
endmodule
