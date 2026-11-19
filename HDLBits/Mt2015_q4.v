module top_module (input x, input y, output z);

    // Fios que recebem as saídas dos módulos
    wire z1, z2, z3, z4;

    // Instâncias dos módulos
    mod_a A1 (.x(x), .y(y), .z(z1));
    mod_a A2 (.x(x), .y(y), .z(z2));
    mod_b B1 (.x(x), .y(y), .z(z3));
    mod_b B2 (.x(x), .y(y), .z(z4));

    // CORREÇÃO: usar os fios (z1, z2, z3, z4) e arrumar os operadores
    // Lógica: (A1 OR B1) XOR (A2 AND B2)
    assign z = (z1 | z3) ^ (z2 & z4);

endmodule

// --- DEFINIÇÃO DOS SUBMÓDULOS (Resolve o erro 12006) ---

// Módulo A (do mt2015_q4a)
module mod_a (input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Módulo B (do mt2015_q4b)
// Baseado na sua solução que passou, a lógica é XNOR
module mod_b (input x, input y, output z);
    assign z = ~(x ^ y); 
endmodule
