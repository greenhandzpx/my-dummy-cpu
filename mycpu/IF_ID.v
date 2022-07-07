module IF_ID(
  input wire clk,
  input wire rst_n,

  input wire [31:0] if_pc4_i,
  input wire [31:0] if_inst_i,

  output reg [31:0] id_pc4_o,
  output reg [31:0] id_inst_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        id_pc4_o <= 31'h0;
    end
    else begin
        id_pc4_o <= if_pc4_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        id_inst_o <= 31'h0;
    end
    else begin
        id_inst_o <= if_inst_i;
    end
end

endmodule