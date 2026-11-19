/*Build a minimal single-instruction datapath: an 8-entry, 8-bit register file with 
two combinational read ports feeding an ALU, and a synchronous write-back port. 
This models the core of one instruction slot in a simple processor.
*/

module top_module (
    input clk,
    input reset,
    input [2:0] rs1_addr,
    input [2:0] rs2_addr,
    input [2:0] rd_addr,
    input reg_write,
    input [2:0] alu_op,
    input [7:0] imm,
    input imm_src,
    output [7:0] rs1_data,
    output [7:0] rs2_data,
    output [7:0] alu_result
);
    reg [7:0] regfile [0:7];
    integer i;

    // Combinational read ports
    assign rs1_data = regfile[rs1_addr];
    assign rs2_data = regfile[rs2_addr];

    // Combinational ALU (add/sub/and/or/xor, same opcode map as the ALU problem)
    reg [7:0] alu_out;
    always @(*) begin
        case (alu_op)
            3'b000: alu_out = rs1_data + rs2_data;
            3'b001: alu_out = rs1_data + (~rs2_data) + 8'd1;
            3'b010: alu_out = rs1_data & rs2_data;
            3'b011: alu_out = rs1_data | rs2_data;
            3'b100: alu_out = rs1_data ^ rs2_data;
            default: alu_out = 8'd0;
        endcase
    end
    assign alu_result = alu_out;

    // Synchronous, single-ported writeback
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                regfile[i] <= 8'd0;
        end else if (reg_write) begin
            regfile[rd_addr] <= imm_src ? imm : alu_result;
        end
    end
endmodule
