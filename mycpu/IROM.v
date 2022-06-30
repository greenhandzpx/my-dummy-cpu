module IROM (
    input wire[31:0] pc,
    output wire[31:0] inst
);

prgrom U0_irom (
    .a (pc[15:2]),
    .spo (inst)
);

endmodule