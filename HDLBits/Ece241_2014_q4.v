module top_module (
    input clk,
    input x,
    output z
); 
    
    // Declaração dos três flip-flops internos
    reg q0, q1, q2;

    // Processo sequencial para atualizar os Flip-Flops na borda do clock
    always @(posedge clk) begin
        q0 <= x ^ q0; // Topo: XOR
        q1 <= x & q1; // Meio: AND
        q2 <= x | q2; // Baixo: OR
    end

    // Saída Z (Porta NOR das três saídas)
    assign z = ~(q0 | q1 | q2);

endmodule