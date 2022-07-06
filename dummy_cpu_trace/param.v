module PARAM();

`ifndef _CPU_PARAM_
`define _CPU_PARAM_

    `define ADD 4'b0000
    `define SUB 4'b0001
    `define AND 4'b0010
    `define OR  4'b0011
    `define XOR 4'b0100
    `define SLL 4'b0101
    `define SRL 4'b0110
    `define SRA 4'b0111
    `define BEQ 4'b1000
    `define BNE 4'b1001
    `define BLT 4'b1010
    `define BGE 4'b1011

    `define DIGIT_BASE_ADDR  32'hffff_f000
    `define LED_BASE_ADDR    32'hffff_f060
    `define SWITCH_BASE_ADDR 32'hffff_f070
    `define BUTTON_BASE_ADDE 32'hffff_f078
`endif

endmodule
