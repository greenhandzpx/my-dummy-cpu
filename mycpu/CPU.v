module CPU(
    input clk,
    input rst_n,

    input wire [31:0] if_inst_i,
    input wire [31:0] RD_i,

    output wire [31:0] pc_o,
    output wire [31:0] mem_resC_o,
    output wire [31:0] mem_rD2_o,
    output wire mem_mem_write_o,

    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);


// reg [31:0] pc;
wire [31:0] npc;
// wire [31:0] inst;

// ctrl
wire [1:0] id_pc_sel;
wire [1:0] id_reg_write;
wire id_ctrl_branch;
wire [3:0] id_alu_ctrl;
wire id_op_B_sel;
wire [2:0] sext_op;
wire id_mem_write;
assign mem_write = id_mem_write;


// rf
wire id_reg_we;
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

wire [31:0] id_opA = rD1;
wire [31:0] id_opB = (id_op_B_sel == 1'b0) ? ext : rD2;


// IF/ID
wire [31:0] if_pc4 = pc_o + 3'h4;
wire [31:0] id_pc4;
wire [31:0] id_inst;
IF_ID u_if_id(
    .clk(clk),
    .rst_n(rst_n),

    .if_pc4_i(if_pc4),
    .if_inst_i(if_inst_i),

    .id_pc4_o(id_pc4),
    .id_inst_o(id_inst)
);

// ID/EX
wire [1:0] ex_pc_sel;
wire [1:0] ex_reg_write;
wire ex_mem_write;
wire ex_ctrl_branch;
wire [3:0] ex_alu_ctrl;
wire ex_op_B_sel;
wire ex_reg_we;
wire [31:0] ex_opA;
wire [31:0] ex_opB;
wire [31:0] ex_rD2;
wire [31:0] ex_ext;
wire [31:0] ex_pc4;
ID_EX u_id_ex(
    .clk(clk),
    .rst_n(rst_n),

    .id_pc_sel_i(id_pc_sel),
    .id_reg_write_i(id_reg_write),
    .id_mem_write_i(id_mem_write),
    .id_branch_i(id_ctrl_branch),
    .id_alu_ctrl_i(id_alu_ctrl),
    .id_op_B_sel_i(id_op_B_sel),
    .id_reg_we_i(id_reg_we),
    .id_opA_i(id_opA),
    .id_opB_i(id_opB),
    .id_rD2_i(rD2),
    .id_ext_i(ext),
    .id_pc4_i(id_pc4),

    .ex_pc_sel_o(ex_pc_sel),
    .ex_reg_write_o(ex_reg_write),
    .ex_mem_write_o(ex_mem_write),
    .ex_branch_o(ex_ctrl_branch),
    .ex_alu_ctrl_o(ex_alu_ctrl),
    .ex_op_B_sel_o(ex_op_B_sel),
    .ex_reg_we_o(ex_reg_we),
    .ex_opB_o(ex_opB),
    .ex_opA_o(ex_opA),
    .ex_rD2_o(ex_rD2),
    .ex_ext_o(ex_ext),
    .ex_pc4_o(ex_pc4)
);

// EX/MEM
wire [1:0] mem_reg_write;
// wire [1:0] mem_mem_write;
wire mem_reg_we;
// wire [31:0] mem_resC;
// wire [31:0] mem_rD2;
wire [31:0] mem_ext;
wire [31:0] mem_pc4;
EX_MEM u_ex_mem(
    .clk(clk),
    .rst_n(rst_n),

    .ex_reg_write_i(ex_reg_write),
    .ex_mem_write_i(ex_mem_write),
    .ex_reg_we_i(ex_reg_we),
    .ex_resC_i(resC),
    .ex_rD2_i(ex_rD2),
    .ex_ext_i(ex_ext),
    .ex_pc4_i(ex_pc4),

    .mem_reg_write_o(mem_reg_write),
    .mem_mem_write_o(mem_mem_write_o),
    .mem_reg_we_o(mem_reg_we),
    .mem_resC_o(mem_resC_o),
    .mem_rD2_o(mem_rD2_o),
    .mem_ext_o(mem_ext),
    .mem_pc4_o(mem_pc4)
);


// MEM/WB
wire wb_reg_we;
wire [31:0] wb_wD;
MEM_WB u_mem_wb(
    .clk(clk),
    .rst_n(rst_n),

    .mem_reg_we_i(mem_reg_we),
    .mem_wD_i(wD),

    .wb_reg_we_o(wb_reg_we),
    .wb_wD_o(wb_wD)
);



PC u_pc(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .npc(npc),
    // output
    .pc(pc_o)
    // .next_iter(debug_wb_have_inst)
);

assign jump = alu_branch & ex_ctrl_branch;
NPC u_npc(
    .jump(jump),
    .pc_sel(pc_sel),
    .pc(pc_o),
    .imm(ext),
    .base_adr(rD1),
    .npc(npc),
    .pc4(pc4)
);

CTRL u_ctrl(
    // input
    .func3(id_inst[14:12]),
    .func7(id_inst[31:25]),
    .opcode(id_inst[6:0]),
    // output
    .pc_sel(id_pc_sel),
    .reg_write(id_reg_write),
    .mem_write(id_mem_write),
    .branch(id_ctrl_branch),
    .alu_ctrl(id_alu_ctrl),
    .op_B_sel(id_op_B_sel),
    .sext_op(sext_op),
    .reg_we(id_reg_we)
);

SEXT u_sext(
    .inst(id_inst),
    .sext_op(sext_op),
    .ext(ext)
);

assign wD = (mem_reg_write == 2'b00) ? mem_resC_o :
            (mem_reg_write == 2'b01) ? mem_pc4  :    
            (mem_reg_write == 2'b10) ? RD_i   : 
            (mem_reg_write == 2'b11) ? mem_ext : 32'h0000_0000;
RF u_rf(
    // input
    .clk(clk),
    .rR1(id_inst[19:15]),
    .rR2(id_inst[24:20]),
    .wR(id_inst[11:7]),
    .WE(wb_reg_we),
    .WD(wb_wD),
    // output
    .rD1(rD1),
    .rD2(rD2)
);

ALU u_alu(
    .opA(ex_opA),
    .opB(ex_opB),
    .op(ex_alu_ctrl),
    .branch(alu_branch),
    .resC(resC)
);


// output of the cpu
assign debug_wb_have_inst = 1'b1;
assign debug_wb_pc = pc_o;
assign debug_wb_ena = wb_reg_we;
assign debug_wb_reg = id_inst[11:7];
// assign debug_wb_value = wD;
assign debug_wb_value = wb_wD;


endmodule