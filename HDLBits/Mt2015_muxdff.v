module circuito_completo (
    input clk,
    input L,
    input r0, r1, r2,
    output Q0, Q1, Q2
);

    // Fio para guardar o resultado da porta XOR
    wire xor_out;

    // 1ª Instância (Bloco da esquerda)
    top_module bloco0 (
        .clk(clk),
        .L(L),
        .r_in(r0),
        .q_in(Q2),    // Recebe a realimentação do último bloco
        .Q(Q0)
    );

    // 2ª Instância (Bloco do meio)
    top_module bloco1 (
        .clk(clk),
        .L(L),
        .r_in(r1),
        .q_in(Q0),    // Recebe a saída do bloco 0
        .Q(Q1)
    );

    // Porta XOR (Q1 ^ Q2)
    assign xor_out = Q1 ^ Q2;

    // 3ª Instância (Bloco da direita)
    top_module bloco2 (
        .clk(clk),
        .L(L),
        .r_in(r2),
        .q_in(xor_out), // Recebe o resultado do XOR
        .Q(Q2)
    );

endmodule


// --- Seu submódulo original (MUX + DFF) ---
module top_module (
    input clk,
    input L,
    input r_in,
    input q_in,
    output reg Q
);
    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_in;
    end
endmodule
