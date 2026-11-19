module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
); 

    // Fios de controle (Cascata)
    // Minutos só incrementam se os segundos estiverem em 59
    wire ena_mm = ena && (ss == 8'h59);
    
    // Horas só incrementam se os minutos estiverem em 59 (e, consequentemente, os segundos também)
    wire ena_hh = ena_mm && (mm == 8'h59);

    always @(posedge clk) begin
        if (reset) begin
            // Reset síncrono para 12:00:00 AM
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else begin
            
            // --- Lógica dos Segundos (ss) ---
            if (ena) begin
                if (ss == 8'h59) begin
                    ss <= 8'h00;
                end else if (ss[3:0] == 4'd9) begin
                    ss[3:0] <= 4'd0;
                    ss[7:4] <= ss[7:4] + 1;
                end else begin
                    ss[3:0] <= ss[3:0] + 1;
                end
            end

            // --- Lógica dos Minutos (mm) ---
            if (ena_mm) begin
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                end else if (mm[3:0] == 4'd9) begin
                    mm[3:0] <= 4'd0;
                    mm[7:4] <= mm[7:4] + 1;
                end else begin
                    mm[3:0] <= mm[3:0] + 1;
                end
            end

            // --- Lógica das Horas (hh) ---
            if (ena_hh) begin
                if (hh == 8'h12) begin
                    hh <= 8'h01; // Vira de 12 para 01
                end else if (hh[3:0] == 4'd9) begin
                    hh[3:0] <= 4'd0;
                    hh[7:4] <= 4'd1; // Vira de 09 para 10
                end else begin
                    hh[3:0] <= hh[3:0] + 1;
                end
            end

            // --- Lógica do PM/AM ---
            // Só alterna quando a hora atual for 11 E o relógio estiver prestes a virar para 12
            if (ena_hh && (hh == 8'h11)) begin
                pm <= ~pm;
            end
            
        end
    end

endmodule
