module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z 
);
    
    // O nosso registrador de deslocamento interno (8 bits)
    reg [7:0] Q;
    
    // 1. O Shift Register (desloca na borda do clock, se habilitado)
    always @(posedge clk) begin
        if (enable) begin
            // O bit 'S' entra na posição Q[0], e os outros vão para a esquerda
            Q <= {Q[6:0], S}; 
        end
    end
    
    // 2. O Multiplexador 8-para-1
    // O valor {A, B, C} forma um índice de 0 a 7 que escolhe qual bit de Q vai para Z
    // 2. O Multiplexador 8-to-1 usando CASE
    always @(*) begin
        case ({A, B, C})
            3'd0: Z = Q[0];
            3'd1: Z = Q[1];
            3'd2: Z = Q[2];
            3'd3: Z = Q[3];
            3'd4: Z = Q[4];
            3'd5: Z = Q[5];
            3'd6: Z = Q[6];
            3'd7: Z = Q[7];
        endcase
    end
    
endmodule




/*
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z 
);
    
    // O nosso registrador de deslocamento interno (8 bits)
    reg [7:0] Q;
    
    // 1. O Shift Register (desloca na borda do clock, se habilitado)
    always @(posedge clk) begin
        if (enable) begin
            // O bit 'S' entra na posição Q[0], e os outros vão para a esquerda
            Q <= {Q[6:0], S}; 
        end
    end
    
    // 2. O Multiplexador 8-para-1
    // O valor {A, B, C} forma um índice de 0 a 7 que escolhe qual bit de Q vai para Z
    assign Z = Q[{A, B, C}];

endmodule

*/