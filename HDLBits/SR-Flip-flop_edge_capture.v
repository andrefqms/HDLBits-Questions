module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;

    always @(posedge clk) begin
        if (reset) begin
            // O reset tem prioridade máxima: limpa a saída
            out <= 32'b0; 
        end else begin
            // 'out' se mantém 1 (out) OU captura uma nova descida (in_prev & ~in)
            out <= out | (in_prev & ~in); 
        end
        
        // Sempre guarda o estado atual da entrada para o próximo ciclo
        in_prev <= in; 
    end

endmodule
