module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out
);  

    parameter A=0, B=1; 
    reg state, next_state;

    // 1. Lógica Combinacional (Próximo Estado)
    always @(*) begin    
        case(state)
            A: next_state = in ? A : B; // Se in=1 vai pra B, senão fica em A
            B: next_state = in ? B : A; // Se in=1 fica em B, senão vai pra A
            default: next_state = B;    // Segurança
        endcase
    end

    // 2. Lógica Sequencial (Flip-Flop e Reset Assíncrono)
    always @(posedge clk, posedge areset) begin    
        if(areset)
            state <= B; // O ponto e vírgula aqui é OBRIGATÓRIO
        else 
            state <= next_state;
    end

    // 3. Lógica de Saída (Moore)
    assign out = (state == B ? 1:0);

endmodule 