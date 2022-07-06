module CPU(
    input clk,
    input rst_n,

    input wire [31:0] inst,
    input wire [31:0] RD,

    output wire [31:0] pc,
    output wire [31:0] resC,
    output wire [31:0] rD2,
    output wire mem_write,
    
    // debug
    output wire [31:0] npc_o
);


// reg [31:0] pc;
wire [31:0] npc;
// wire [31:0] inst;
assign npc_o = npc;

// ctrl
wire [1:0] pc_sel;
wire [1:0] reg_write;
// wire mem_write;
wire ctrl_branch;
wire [3:0] alu_ctrl;
wire op_B_sel;
wire [2:0] sext_op;

// rf
wire reg_we;
wire [31:0] wD; 
wire [31:0] rD1;
// wire [31:0] rD2;

// alu
wire [31:0] opB;
wire alu_branch;
// wire [31:0] resC;

// npc
wire jump;
wire [31:0] pc4;

// sext
wire [31:0] ext;

// dm
// wire [31:0] RD;  

PC u_pc(
    .clk(clk),
    .rst_n(rst_n),
    .npc(npc),
    .pc(pc)
//    .next_iter(debug_wb_have_inst)
);

assign jump = alu_branch & ctrl_branch;
NPC u_npc(
    .jump(jump),
    .pc_sel(pc_sel),
    .pc(pc),
    .imm(ext),
    .base_adr(rD1),
    .npc(npc),
    .pc4(pc4)
);

CTRL u_ctrl(
    .func3(inst[14:12]),
    .func7(inst[31:25]),
    .opcode(inst[6:0]),
    .pc_sel(pc_sel),
    .reg_write(reg_write),
    .mem_write(mem_write),
    .branch(ctrl_branch),
    .alu_ctrl(alu_ctrl),
    .op_B_sel(op_B_sel),
    .sext_op(sext_op),
    .reg_we(reg_we)
);

SEXT u_sext(
    .inst(inst),
    .sext_op(sext_op),
    .ext(ext)
);

assign wD = (reg_write == 2'b00) ? resC :
            (reg_write == 2'b01) ? pc4  :    
            (reg_write == 2'b10) ? RD   : 
            (reg_write == 2'b11) ? ext  : 32'h0000_0000;
RF u_rf(
    .clk(clk),
    .WE(reg_we),
    .rR1(inst[19:15]),
    .rR2(inst[24:20]),
    .wR(inst[11:7]),
    .WD(wD),
    .rD1(rD1),
    .rD2(rD2)
);


assign opB = (op_B_sel == 1'b0) ? ext : rD2;
ALU u_alu(
    .opA(rD1),
    .opB(opB),
    .op(alu_ctrl),
    .branch(alu_branch),
    .resC(resC)
);


//// output of the cpu
//// assign debug_wb_have_inst = 1'b1;
//assign debug_wb_pc = pc;
//assign debug_wb_ena = reg_we;
//assign debug_wb_reg = inst[11:7];
//// assign debug_wb_value = wD;
//assign debug_wb_value = wD;


endmodule