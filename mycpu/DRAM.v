module DRAM (
    input wire clk,
    input wire WE,        // write enable
    input wire[15:0] Adr, 
    input wire[31:0] WD,  // write to ram(load)
    output reg[31:0] RD   // write back to register(store)
);

// 64KB DRAM
dram U_dram (
    .clk(clk),
    .a  (Adr[15:2]),
    .spo(RD),
    .we (WE),
    .d  (WD)
);


endmodule