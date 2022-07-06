module EXTERNAL_DEVICE(
    input wire clk_i,
    input wire rst_i,
    
    // debug
    input wire [31:0] inst,
    input wire [31:0] npc_i,
    
    // external devices I/O
    // switches
    input wire [23:0] switches_i,
    // buttons
    input wire [4:0] buttons_i,
    // leds
    output wire [23:0] led_en_o,   
    // digits
    output wire [7:0] digit_en_o,
    output wire digit_ca_o,
    output wire digit_cb_o,
    output wire digit_cc_o,
    output wire digit_cd_o,
    output wire digit_ce_o,
    output wire digit_cf_o,
    output wire digit_cg_o,
    output wire digit_dp_o,
    
    // universial dram I/O
    input wire [31:0] dram_addr_i,
    input wire dram_we_i,
    input wire [31:0] dram_wdata_i,
    output wire [31:0] dram_rdata_o
);

wire rst_n = !rst_i;

// leds
wire led_wr = dram_we_i & (dram_addr_i == `LED_BASE_ADDR);
// led data
reg [23:0] led_en;
reg [31:0] cnt;
always @(posedge clk_i or negedge rst_n) begin
    if (~rst_n) begin
        led_en <= 24'h0;

    end
//    else if (inst == 32'hff5ff0ef) begin
//        cnt <= cnt + 1'b1;
//        led_en <= {2'b11, npc_i[21:0]};
//    end  
//    else if (cnt == 5'h5) begin
//        led_en <= 24'h888888;
//    end
    else if (led_wr) begin
//        cnt <= cnt + 1'b1;
        led_en <= dram_wdata_i[23:0];
    end  
    
end
assign led_en_o = led_en;

// digits
wire digit_wr = dram_we_i & (dram_addr_i == `DIGIT_BASE_ADDR);
// digit data
reg [31:0] digit_wdata;
always @(posedge clk_i or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 32'h0;
        digit_wdata <= 32'h0000_0000; 
    end
//    else begin
//        digit_wdata <= npc_i;
//    end
//    else if (cnt == 9999999) begin
//        cnt <= 32'h0;
//        digit_wdata <= npc_i;
//    end
//    else begin
//        cnt <= cnt + 1'b1;
//    end
//    else if (inst == 32'h0084a023) begin
//        digit_wdata <= npc_i;
//    end  
    else if (digit_wr) begin
        digit_wdata <= dram_wdata_i;
    end  
end
RES_DISPLAY result_display(
    .clk(clk_i),
    .rst(rst_i),
    .cal_result(digit_wdata),
    .led_en(digit_en_o),
    .led_ca(digit_ca_o),
    .led_cb(digit_cb_o),
    .led_cc(digit_cc_o),
    .led_cd(digit_cd_o),
    .led_ce(digit_ce_o),
    .led_cf(digit_cf_o),
    .led_cg(digit_cg_o),
    .led_dp(digit_dp_o)
);

// we have two kinds of universial output
assign dram_rdata_o = (dram_addr_i == `SWITCH_BASE_ADDR) ? {8'h00, switches_i} : 
                      (dram_addr_i == `BUTTON_BASE_ADDR) ? {27'h0, buttons_i} : 32'h0000_0000;


endmodule