// Add your code here, or replace this file
module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);

wire [31:0] if_inst;
wire [31:0] RD;
wire [31:0] pc;
wire [31:0] resC;
wire [31:0] rD2;
wire mem_write;

CPU u_cpu(
    // input
    .clk(clk),
    .rst_n(rst_n),

    .if_inst_i(if_inst),
    .RD_i(RD),

    // output 
    .pc_o(pc),
    .mem_resC_o(resC),
    .mem_rD2_o(rD2),
    .mem_mem_write_o(mem_write),

    .debug_wb_have_inst (debug_wb_have_inst),
    .debug_wb_pc        (debug_wb_pc),
    .debug_wb_ena       (debug_wb_ena),
    .debug_wb_reg       (debug_wb_reg),
    .debug_wb_value     (debug_wb_value)
);


// 下面两个模块，只需要实例化并连线，不需要添加文件
IROM imem(
    .pc (pc),
    .inst (if_inst)
);
// inst_mem imem(
//     .a (pc[15:2]),
//     .spo (inst)
// );

data_mem dmem(
    .clk(clk),
    .a  (resC[15:2]),
    .spo(RD),
    .we (mem_write),
    .d  (rD2)
);

endmodule
