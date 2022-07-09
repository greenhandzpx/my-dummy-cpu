module NPC(
    input wire jump,
    input wire[1:0] pc_sel,
    input wire[31:0] pc_now,
    input wire [31:0] ex_pc,
    input wire[31:0] imm,
    input wire[31:0] base_adr,
    output wire[31:0] npc,
    output wire[31:0] pc4
);

assign pc4 = pc_now + 3'h4;

// 00 ---> pc + 4
// 11 ---> pc + imm(b)
// 10 ---> base_adr + imm(jalr)
// 01 ---> pc + imm(jal)
// assign npc = pc + 3'h4;
assign npc = pc_sel == 2'b00 ? pc_now + 3'h4 :
             pc_sel == 2'b01 ? ex_pc + imm  :
             pc_sel == 2'b10 ? base_adr + imm :
             jump == 1'b1    ? ex_pc + imm : ex_pc + 3'h4;


endmodule