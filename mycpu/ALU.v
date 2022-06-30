module ALU(
    input wire[31:0] opA,
    input wire[31:0] opB,
    input wire[3:0]  op,
    output wire branch,
    output wire[31:0] resC
);

reg[31:0] resC_reg;
reg branch_reg;

assign resC = resC_reg;
assign branch = branch_reg;

always @(*) begin
    case (op)
        4'b0000: resC_reg = opA + opB;
        4'b0001: resC_reg = opA + ~opB + 1'b1;
        4'b0010: resC_reg = opA & opB;
        4'b0011 : resC_reg = opA | opB;
        4'b0100: resC_reg = opA ^ opB;
        4'b0101: resC_reg = opA << opB;
        4'b0110: resC_reg = opA >> opB;
        4'b0111: resC_reg = ($signed(opA)) >>> opB;
        4'b1000: branch_reg = opA == opB ? 1'b1 : 1'b0;
        4'b1001: branch_reg = opA == opB ? 1'b0 : 1'b1;
        4'b1010: branch_reg = ($signed(opA)) < ($signed(opB)) ? 1'b1 : 1'b0;
        4'b1011: branch_reg = ($signed(opA)) < ($signed(opB)) ? 1'b0 : 1'b1;
        // `ADD: resC_reg = opA + opB;
        // `SUB: resC_reg = opA + ~opB + 1'b1;
        // `AND: resC_reg = opA & opB;
        // `OR : resC_reg = opA | opB;
        // `XOR: resC_reg = opA ^ opB;
        // `SLL: resC_reg = opA << opB;
        // `SRL: resC_reg = opA >> opB;
        // `SRA: resC_reg = ($signed(opA)) >>> opB;
        // `BEQ: branch_reg = opA == opB ? 1'b1 : 1'b0;
        // `BNE: branch_reg = opA == opB ? 1'b0 : 1'b1;
        // `BLT: branch_reg = ($signed(opA)) < ($signed(opB)) ? 1'b1 : 1'b0;
        // `BGE: branch_reg = ($signed(opA)) < ($signed(opB)) ? 1'b0 : 1'b1;
    endcase
end


endmodule