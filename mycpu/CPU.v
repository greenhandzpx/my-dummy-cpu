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
wire rD1_re;  // register1 read enable
wire rD2_re;  // register2 read enable
wire mem_read;// memory read enable


// rf
wire id_reg_we;
wire [31:0] wD; 
wire [31:0] rD1;
wire [31:0] rD2;

// alu
wire [31:0] opB;
wire alu_branch;
wire [31:0] resC;

// npc
wire jump;
wire [31:0] pc4;

// sext
wire [31:0] ext;

// dm
// wire [31:0] RD;  

// wire [31:0] id_opA = rD1;
// wire [31:0] id_opB = (id_op_B_sel == 1'b0) ? ext : rD2;
wire [31:0] id_opA;
wire [31:0] id_opB;


// pipeline stop signal
wire [1:0] pipeline_stop;
wire [1:0] pipeline_stop_branch;
wire [1:0] pipeline_stop_load_use;

// IF/ID
wire [31:0] if_pc4 = pc_o + 3'h4;
wire [31:0] id_pc4;
wire [31:0] id_inst;
IF_ID u_if_id(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop_i(pipeline_stop_load_use),
    .pipeline_stop_branch_i(pipeline_stop_branch),

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
wire [4:0] ex_wR;
wire ex_mem_read;
// wire pipeline_stop_id_ex = 1'b0;
ID_EX u_id_ex(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop_i(pipeline_stop_load_use),

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
    .id_wR_i(id_inst[11:7]),
    .id_mem_read_i(mem_read),

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
    .ex_pc4_o(ex_pc4),
    .ex_wR_o(ex_wR),
    .ex_mem_read_o(ex_mem_read)
);

// EX/MEM
wire [1:0] mem_reg_write;
// wire [1:0] mem_mem_write;
wire mem_reg_we;
// wire [31:0] mem_resC;
// wire [31:0] mem_rD2;
wire [31:0] mem_ext;
wire [31:0] mem_pc4;
wire [4:0] mem_wR;
wire mem_mem_read;
wire pipeline_stop_ex_mem = 1'b0;
EX_MEM u_ex_mem(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop_i(pipeline_stop_ex_mem),

    .ex_reg_write_i(ex_reg_write),
    .ex_mem_write_i(ex_mem_write),
    .ex_reg_we_i(ex_reg_we),
    .ex_resC_i(resC),
    .ex_rD2_i(ex_rD2),
    .ex_ext_i(ex_ext),
    .ex_pc4_i(ex_pc4),
    .ex_wR_i(ex_wR),
    .ex_mem_read_i(ex_mem_read),

    .mem_reg_write_o(mem_reg_write),
    .mem_mem_write_o(mem_mem_write_o),
    .mem_reg_we_o(mem_reg_we),
    .mem_resC_o(mem_resC_o),
    .mem_rD2_o(mem_rD2_o),
    .mem_ext_o(mem_ext),
    .mem_pc4_o(mem_pc4),
    .mem_wR_o(mem_wR),
    .mem_mem_read_o(mem_mem_read)
);

// MEM/WB
wire wb_reg_we;
wire [31:0] wb_wD;
wire [4:0] wb_wR;
wire pipeline_stop_mem_wb = 1'b0;
wire [31:0] wb_pc4_debug;
MEM_WB u_mem_wb(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop_i(pipeline_stop_mem_wb),

    .mem_reg_we_i(mem_reg_we),
    .mem_wD_i(wD),
    .mem_wR_i(mem_wR),
    .mem_pc4_i_debug(mem_pc4),

    .wb_reg_we_o(wb_reg_we),
    .wb_wD_o(wb_wD),
    .wb_wR_o(wb_wR),
    .wb_pc4_o_debug(wb_pc4_debug)
);

// data hazards
// 1. ID EX hazard
wire rs1_id_ex_hazard = (ex_wR != 5'h0 && ex_wR == id_inst[19:15]) & ex_reg_we & rD1_re;
wire rs2_id_ex_hazard = (ex_wR != 5'h0 && ex_wR == id_inst[24:20]) & ex_reg_we & rD2_re;
// 2. ID MEM hazard
wire rs1_id_mem_hazard = !rs1_id_ex_hazard & (mem_wR != 5'h0 && mem_wR == id_inst[19:15]) & mem_reg_we & rD1_re;
wire rs2_id_mem_hazard = !rs2_id_ex_hazard & (mem_wR != 5'h0 && mem_wR == id_inst[24:20]) & mem_reg_we & rD2_re;
// 3. ID WB hazard
wire rs1_id_wb_hazard = !rs1_id_mem_hazard & (wb_wR != 5'h0 && wb_wR == id_inst[19:15]) & wb_reg_we & rD1_re;
wire rs2_id_wb_hazard = !rs2_id_mem_hazard & (wb_wR != 5'h0 && wb_wR == id_inst[24:20]) & wb_reg_we & rD2_re;
// 4. load-use hazard
wire rs1_load_use_hazard = ex_mem_read & (ex_wR != 5'h0) & (ex_wR == id_inst[19:15]) & ex_reg_we & rD1_re;
wire rs2_load_use_hazard = ex_mem_read & (ex_wR != 5'h0) & (ex_wR == id_inst[24:20]) & ex_reg_we & rD2_re;

// control hazards
// jalr, jal, b series
wire branch_hazard = (id_inst[6:0] == 7'b1100111 || id_inst[6:0] == 7'b1100011 || id_inst[6:0] == 7'b1101111) &
                        !ex_ctrl_branch;

// pipeline stop signal
assign pipeline_stop = 2'h0;
// assign pipeline_stop = (rs1_id_ex_hazard | rs2_id_ex_hazard) ? 2'h3 :
//                        (rs1_id_mem_hazard | rs2_id_mem_hazard) ? 2'h2 :
//                        (rs1_id_wb_hazard | rs2_id_wb_hazard) ? 2'h1 : 2'h0;

// branch stop
assign pipeline_stop_branch = branch_hazard ? 2'h2 : 2'h0;
// load-use stop
assign pipeline_stop_load_use = rs1_load_use_hazard | rs2_load_use_hazard;


// forward data 
assign id_opA = rs1_id_ex_hazard ? resC : 
                rs1_id_mem_hazard ? (mem_mem_read ? RD_i : mem_resC_o) :
                rs1_id_wb_hazard ? wb_wD :
                rD1;

assign id_opB = rs2_id_ex_hazard ? resC : 
                rs2_id_mem_hazard ? mem_resC_o :
                rs2_id_wb_hazard ? wb_wD :
                (id_op_B_sel == 1'b0) ? ext : rD2;




PC u_pc(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .npc(npc),
    .pipeline_stop_i(pipeline_stop_load_use),
    .pipeline_stop_branch_i(pipeline_stop_branch),

    // output
    .pc(pc_o)
    // .next_iter(debug_wb_have_inst)
);

assign jump = alu_branch & ex_ctrl_branch;
wire [31:0] ex_pc = ex_pc4 + ~3'h4 + 1;
NPC u_npc(
    // input
    .jump(jump),
    .pc_sel(ex_pc_sel),
    .pc_now(pc_o),
    .imm(ex_ext),
    .base_adr(ex_opA),
    .ex_pc(ex_pc),
    // output
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
    .reg_we(id_reg_we),
    .rD1_re(rD1_re),
    .rD2_re(rD2_re),
    .mem_read(mem_read)
);

SEXT u_sext(
    .inst(id_inst),
    .sext_op(sext_op),
    .ext(ext)
);

assign wD = (mem_reg_write == 2'b00) ? mem_resC_o :
            (mem_reg_write == 2'b01) ? mem_pc4  :    
            (mem_reg_write == 2'b10) ? RD_i   : 32'h0000_0000;
            // (mem_reg_write == 2'b11) ? mem_ext : 32'h0000_0000;
// debug
wire [31:0] debug_x4;
RF u_rf(
    // input
    .clk(clk),
    .rR1(id_inst[19:15]),
    .rR2(id_inst[24:20]),
    .wR(wb_wR), 
    .WE(wb_reg_we),
    .WD(wb_wD),
    // output
    .rD1(rD1),
    .rD2(rD2),
    // debug
    .debug_x4(debug_x4)
);

ALU u_alu(
    .opA(ex_opA),
    .opB(ex_opB),
    .op(ex_alu_ctrl),
    .branch(alu_branch),
    .resC(resC)
);


// output of the cpu
assign debug_wb_have_inst = wb_pc4_debug[31] != 1'b1 && wb_pc4_debug != 0;
// assign debug_wb_have_inst = 1'b1;
assign debug_wb_pc = wb_pc4_debug + ~3'h4 + 1;
// assign debug_wb_pc = id_pc4 - 3'h4;
// assign debug_wb_pc = pc_o;
assign debug_wb_ena = wb_reg_we;
assign debug_wb_reg = wb_wR;
// assign debug_wb_reg = ex_pc_sel;
// assign debug_wb_reg = pipeline_stop_branch;
// assign debug_wb_value = ex_alu_ctrl;
// assign debug_wb_value = id_inst[24:20];
assign debug_wb_value = wb_wD;
// assign debug_wb_value = rs1_load_use_hazard;
// assign debug_wb_value ={24'h0, 3'b000, pipeline_stop, 3'b000,pipeline_stop_branch};
// assign debug_wb_value = RD_i;
// assign debug_wb_value = ex_pc_sel;
// assign debug_wb_value = {3'h0, id_inst[11:7], 3'b000, ex_wR, 3'b000, mem_wR, 3'b000, wb_wR};
// assign debug_wb_value = {3'h0, id_inst[11:7], 3'b000, ex_wR, 3'b000, id_ctrl_branch, 3'b000, ex_ctrl_branch};
// assign debug_wb_value = id_inst;


endmodule