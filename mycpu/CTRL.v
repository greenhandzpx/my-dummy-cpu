module CTRL(
    input wire [2:0] func3,
    input wire [6:0] func7,
    input wire [6:0] opcode,
    output wire [1:0] pc_sel,
    output wire [1:0] reg_write,
    output wire mem_write,
    output wire branch,
    output wire [3:0] alu_ctrl,  
    output wire op_B_sel,   // select operandB
    output wire [2:0] sext_op,
    output wire reg_we,      // rf's we
    output wire rD1_re,  // register 1 read enable
    output wire rD2_re   // register 2 read enable
);

// Only lui & jal don't have rs1.
assign rD1_re = (opcode == 7'b0110111 || opcode == 7'b1101111) ? 1'b0 : 1'b1;
// Only R series & B series have rs2
assign rD2_re = (opcode == 7'b0110011 || opcode == 7'b1100011) ? 1'b1 : 1'b0;


assign reg_we = (opcode == 7'b1100011 || opcode == 7'b0100011) ? 1'b0 : 1'b1;
//                    ^ b series               ^ sw

// 00  ---> pc + 4
// 11  ---> pc + imm(b)
// 10  ---> base_adr + imm(jalr)
// 01  ---> pc + imm(jal) 
assign pc_sel = (opcode[6:5] == 2'b11) ? (opcode == 7'b1100111 ? 2'b10 : 
                                          (opcode == 7'b1101111 ? 2'b01 : 2'b11)) : 2'b00;
// assign pc_sel = (opcode[6:5] == 2'b00) ? 2'b00 : { 1'b1, opcode[3]};

// 00 ---> rd = rs1 op rs2
// 01 ---> rd = pc + 4
// 10 ---> rd = mem
// 11 ---> rd = imm (lui)
assign reg_write = (opcode[6:4] == 3'b000) ? 2'b10 : 
                   (opcode[6:5] == 2'b11) ?  2'b01 : 
                   (opcode == 7'b0110111) ?  2'b11 : 2'b00;

assign mem_write = (opcode[6:4] == 3'b010) ? 1'b1 : 1'b0;

// assign branch = ({opcode[6:4], opcode[2]} == 4'b1100) ? 1'b1 : 1'b0;
// here jal & jalr aslo set the branch '1'(to be compatible with pipeline_stop_branch)
assign branch = (opcode == 7'b1100011 || opcode == 7'b1100111 || opcode == 7'b1101111) ? 1'b1 : 1'b0;

// 0000 ---> add
// 0001 ---> sub
// 0010 ---> and
// 0011 ---> or
// 0100 ---> xor
// 0101 ---> sll
// 0110 ---> srl
// 0111 ---> sra
// 1000 ---> beq
// 1001 ---> bne
// 1010 ---> blt
// 1011 ---> bge
assign alu_ctrl = (opcode[6:5] == 2'b11) ? 
                    (
                     // b
                  (func3[2:0] == 3'b000) ? 4'b1000 :
                  (func3[2:0] == 3'b001) ? 4'b1001 :
                  (func3[2:0] == 3'b100) ? 4'b1010 : 4'b1011 
                     ) : (
                     // not b
                  (func3[2:0] == 3'b111) ? 4'b0010 :
                  (func3[2:0] == 3'b110) ? 4'b0011 :
                  (func3[2:0] == 3'b100) ? 4'b0100 :
                  (func3[2:0] == 3'b001) ? 4'b0101 : 
                  (func3[2:0] == 3'b000) ? ((opcode == 7'b0010011) ? 4'b0000 : (func7[5] == 1'b0 ? 4'b0000 : 4'b0001)) :
                  (func3[2:0] == 3'b010) ? 4'b0000 :
                  (func7[5] == 1'b0) ? 4'b0110 : 4'b0111
                     );

// assign alu_ctrl = (opcode[6:5] == 2'b11) ? 
//                     (
//                      // b
//                   (func3[2:0] == 3'b000) ? `BEQ :
//                   (func3[2:0] == 3'b001) ? `BNE :
//                   (func3[2:0] == 3'b100) ? `BLT : `BGE 
//                      ) : (
//                      // not b
//                   (func3[2:0] == 3'b111) ? `AND :
//                   (func3[2:0] == 3'b110) ? `OR :
//                   (func3[2:0] == 3'b100) ? `XOR :
//                   (func3[2:0] == 3'b001) ? `SLL : 
//                   (func3[2:0] == 3'b000) ? ((func7[5] == 1'b0) ? `ADD : `SUB) :
//                   (func7[5] == 1'b0) ? `SRL : `SRA
//                      );

// 0 ---> imm
// 1 ---> rD2
assign op_B_sel = (opcode[6:4] == 3'b001 || func3[2:0] == 3'b010) ? 1'b0 : 1'b1;
//                                              ^ lw/sw

// 000 ---> no imm
// 001 ---> 0000_0000_0000_0000_0000_inst[31:20]
// 010 ---> 0000_0000_0000_0000_0000_inst[31:25|11:7]
// 011 ---> 0000_0000_0000_0000_000_inst[31|7|30:25|11:6]_0;
// 100 ---> inst[31:12]|0000_0000_0000;
// 101 ---> 0000_0000_000_inst[31|19:12|20|30|21]_0
assign sext_op = (opcode == 7'b0110011) ? 3'b000 :   // no
                 (opcode == 7'b1100011) ? 3'b011 :    // beq
                 (opcode == 7'b0100011) ? 3'b010 :    // sw
                 (opcode == 7'b0110111) ? 3'b100 :    // lui
                 (opcode == 7'b1101111) ? 3'b101 :    // jal
                                          3'b001;     // other
endmodule