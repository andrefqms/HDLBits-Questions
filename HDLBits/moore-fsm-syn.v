// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    parameter A=0, B=1; 
    reg state, next_state;

    // 1. Lógica Combinacional (Tabela de Transição)osedge areset
    always @(*) begin    
        case(state)
            A: next_state = in ?  A: B; // Corrigido: se in=1 vai para B
            B: next_state = in ? B : A; // Se in=1 fica em B, se in=0 vai para A
            default: next_state = B;    // Boa prática para evitar latches
        endcase
    end

    // 2. Lógica Sequencial (Flip-Flop com Reset Assíncrono)
    always @(posedge clk) begin    
        if(reset)
            state <= B;
        else
            state <= next_state;
    end
    
    // 3. Lógica de Saída (Moore)
    assign out = (state == B ? 1:0);

endmodule