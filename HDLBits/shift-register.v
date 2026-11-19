//Registrador de Deslocamento (Shift Register) 
//de 64 bits com carga paralela (load) e controle de deslocamento (ena e amount).

module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
); 
    
    always @(posedge clk) begin
        // Usando <= (Non-blocking)
        if(load)
            q <= data;
        else if(ena) begin // Juntei o if(ena) para economizar o "else q = q;"
            case(amount)
                2'b00: q <= q << 1;
                2'b01: q <= q << 8;
                2'b10: q <= {q[63], q[63:1]};
                2'b11: q <= {{8{q[63]}}, q[63:8]};
            endcase
        end
        // Note que não é preciso escrever "else q <= q;". 
        // Se as condições acima não forem atendidas, o registrador mantém o valor automaticamente.
    end

endmodule