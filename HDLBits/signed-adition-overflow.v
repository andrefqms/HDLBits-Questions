module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
); //
 
        always @(*) begin
        // 1. Faz a soma
        s = a + b;
        
        // 2. Por padrão, assumimos que não há overflow
        overflow = 1'b0; 
        
        // 3. Verifica se há overflow
        if (a[7] == b[7]) begin        // Se os sinais de entrada são iguais...
            if (s[7] != a[7] && s[7] != b[7] ) begin    // ...e o sinal do resultado é diferente...
                overflow = 1'b1;       // ...tivemos um overflow!
            end
        end
    end
        

endmodule