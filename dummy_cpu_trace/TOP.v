// Add your code here, or replace this file
module top (
    input  wire clk_i,
    input  wire rst_i,
    output wire [7:0] led_en,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o
    
    

//    output wire   debug_wb_have_inst,   // WB阶段是否有指�? (对单周期CPU，此flag恒为1)
//    output wire[31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意�??)
//    output wire       debug_wb_ena,         // WB阶段的寄存器写使�? (若wb_have_inst=0，此项可为任意�??)
//    output wire[4:0]  debug_wb_reg,         // WB阶段写入的寄存器�? (若wb_ena或wb_have_inst=0，此项可为任意�??)
//    output wire[31:0] debug_wb_value        // WB阶段写入寄存器的�? (若wb_ena或wb_have_inst=0，此项可为任意�??)
);

wire clk;
wire clk_lock;

cpuclk UCLK (
    .clk_in1    (clk_i),
    .locked     (clk_lock),
    .clk_out1   (clk)
);



wire rst_n = !rst_i;

wire [31:0] inst;
wire [31:0] RD;
wire [31:0] pc;
wire [31:0] resC;
wire [31:0] rD2;
wire mem_write;

// trace test's result
wire [31:0] x19_o;

//reg  [31:0] dummy = 32'h99911199;
//assign x19_o = dummy;

RES_DISPLAY u_res_display(
    .clk(clk),
    .rst(rst_i),
    .cal_result(x19_o),
    .led_en(led_en),
    .led_ca(led_ca_o),
    .led_cb(led_cb_o),
    .led_cc(led_cc_o),
    .led_cd(led_cd_o),
    .led_ce(led_ce_o),
    .led_cf(led_cf_o),
    .led_cg(led_cg_o),
    .led_dp(led_dp_o)
);

CPU u_cpu(
    // input
    .clk(clk),
    .rst_n(rst_n),

    .inst(inst),
    .RD(RD),
    // output 
    .pc(pc),
    .resC(resC),
    .rD2(rD2),
    .mem_write(mem_write),
   
    .x19_o(x19_o)

//    .debug_wb_have_inst (debug_wb_have_inst),
//    .debug_wb_pc        (debug_wb_pc),
//    .debug_wb_ena       (debug_wb_ena),
//    .debug_wb_reg       (debug_wb_reg),
//    .debug_wb_value     (debug_wb_value)
);

prgrom imem(
    .a (pc[15:2]),
    .spo (inst)
);

//wire dram_clk = ~clk_i;
wire [31:0] waddr_tmp = resC - 16'h4000;
dram dmem(
    .clk(clk),
    .a  (waddr_tmp[15:2]),
    .spo(RD),
    .we (mem_write),
    .d  (rD2)
);

//data_mem dmem(
//    .clk(clk),
//    .a  (resC[15:2]),
//    .spo(RD),
//    .we (mem_write),
//    .d  (rD2)
//);

endmodule
