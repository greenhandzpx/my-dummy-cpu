module RF(
    input wire clk,
    // input wire rst_n,
    input wire WE,
    input wire[4:0] rR1,
    input wire[4:0] rR2,
    input wire[4:0] wR,
    input wire[31:0] WD,
    output wire[31:0] rD1,
    output wire[31:0] rD2
);

reg[31:0] registers[31:0];

assign rD1 = registers[rR1];
assign rD2 = registers[rR2];

always@(posedge clk) begin
    // if (~rst_n) begin
    // end
    // else begin
    if (WE == 1'b1 && wR != 5'h0) begin
        registers[wR] <= WD;
        registers[0] <= 32'h0000_0000;
    end
    else begin
        registers[0] <= 32'h0000_0000;
    end
    // end
end

endmodule