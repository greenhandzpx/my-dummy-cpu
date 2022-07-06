module TOP (
    input  wire clk_i,
    input  wire rst_i,
    
    // switches
    input  wire [23:0] switches_i,
    // buttons
    input wire [4:0] buttons_i,
    // leds
    output wire [23:0] leds_o,
    // digits
    output wire [7:0] led_en,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o
);

wire cpu_clk;
wire clk_lock;
wire pll_clk; 
wire rst_n = !rst_i;

cpuclk u_clk (
    .reset (rst_i),
    .clk_in1    (clk_i),
    .locked     (clk_lock),
    .clk_out1   (pll_clk)
);
assign cpu_clk = pll_clk & clk_lock;



wire [31:0] inst;
wire [31:0] RD;
wire [31:0] pc;
wire [31:0] resC;
wire [31:0] rD2;
wire mem_write;

// debug
wire [31:0] npc;

CPU u_cpu(
    // input
    .clk(cpu_clk),
    .rst_n(rst_n),

    .inst(inst),
    .RD(RD),
    // output 
    .pc(pc),
    .resC(resC),
    .rD2(rD2),
    .mem_write(mem_write),
    // debug
    .npc_o(npc)
);

IROM u_irom(
    .pc (pc),
    .inst (inst)
);

// This one is used to replace the dram
EXTERNAL_DEVICE u_exter_dev(
    .clk_i(cpu_clk),
    .rst_i(rst_i),
   
    // debug
     .inst(inst),  
     .npc_i(npc),
      
    // external device
    .switches_i(switches_i),
    .buttons_i(buttons_i),
    .led_en_o(leds_o),
    .digit_en_o(led_en),
    .digit_ca_o(led_ca_o),
    .digit_cb_o(led_cb_o),
    .digit_cc_o(led_cc_o),
    .digit_cd_o(led_cd_o),
    .digit_ce_o(led_ce_o),
    .digit_cf_o(led_cf_o),
    .digit_cg_o(led_cg_o),
    .digit_dp_o(led_dp_o),
    
    // dram I/O
    .dram_addr_i(resC),
    .dram_we_i(mem_write),
    .dram_wdata_i(rD2),
    .dram_rdata_o(RD)
);


//dram dmem(
//    .clk(clk),
//    .a  (resC[15:2]),
//    .spo(RD),
//    .we (mem_write),
//    .d  (rD2)
//);


endmodule
