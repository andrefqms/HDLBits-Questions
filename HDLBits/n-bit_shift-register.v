module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    wire muxEsquerda, muxDireita;
    
    assign muxEsquerda = E ? w : Q;
    assign muxDireita = L ? R : muxEsquerda;

    
    always @(posedge clk) begin
        Q <=  muxDireita;
    end
    
endmodule
