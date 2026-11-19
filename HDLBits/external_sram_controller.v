module top_module #(
    parameter AW = 10,
    parameter DW = 8
)(
    input  wire             clk,
    input  wire             rst,

    input  wire             req_valid,
    input  wire             req_we,
    input  wire [AW-1:0]    req_addr,
    input  wire [DW-1:0]    req_wdata,
    output wire             req_ready,
    output reg  [DW-1:0]    req_rdata,
    output reg              req_rvalid,

    output reg  [AW-1:0]    sram_addr,
    inout  wire [DW-1:0]    sram_data,
    output reg              sram_ce_n,
    output reg              sram_oe_n,
    output reg              sram_we_n
);

    localparam S_IDLE    = 2'd0,
               S_ACCESS0 = 2'd1,
               S_ACCESS1 = 2'd2,
               S_CAPTURE = 2'd3;

    reg [1:0]    state;
    reg          we_latched;
    reg [DW-1:0] wdata_latched;
    reg          drive_bus;

    assign req_ready = (state == S_IDLE);
    assign sram_data = drive_bus ? wdata_latched : {DW{1'bz}};

    always @(posedge clk) begin
        if (rst) begin
            state      <= S_IDLE;
            sram_ce_n  <= 1'b1;
            sram_oe_n  <= 1'b1;
            sram_we_n  <= 1'b1;
            drive_bus  <= 1'b0;
            req_rvalid <= 1'b0;
            sram_addr  <= {AW{1'b0}};
        end else begin
            req_rvalid <= 1'b0;   // default; overridden in S_CAPTURE for reads

            case (state)
                S_IDLE: begin
                    sram_ce_n <= 1'b1;
                    sram_oe_n <= 1'b1;
                    sram_we_n <= 1'b1;
                    drive_bus <= 1'b0;
                    if (req_valid) begin
                        we_latched    <= req_we;
                        wdata_latched <= req_wdata;
                        sram_addr     <= req_addr;
                        sram_ce_n     <= 1'b0;
                        if (req_we) begin
                            sram_we_n <= 1'b0;
                            drive_bus <= 1'b1;
                        end else begin
                            sram_oe_n <= 1'b0;
                        end
                        state <= S_ACCESS0;
                    end
                end

                S_ACCESS0: state <= S_ACCESS1;   // wait state 1: memory access time
                S_ACCESS1: state <= S_CAPTURE;   // wait state 2: memory access time

                S_CAPTURE: begin
                    if (!we_latched) begin
                        req_rdata  <= sram_data;
                        req_rvalid <= 1'b1;
                    end
                    sram_ce_n <= 1'b1;
                    sram_oe_n <= 1'b1;
                    sram_we_n <= 1'b1;
                    drive_bus <= 1'b0;
                    state     <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
