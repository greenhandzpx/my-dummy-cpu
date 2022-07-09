module MEM_WB(
  input wire clk,
  input wire rst_n,

  input wire mem_reg_we_i,
  input wire [31:0] mem_wD_i,
  input wire [4:0]  mem_wR_i,
  input wire [31:0] mem_pc4_i_debug,

  output reg wb_reg_we_o,
  output reg [31:0] wb_wD_o,
  output reg [4:0] wb_wR_o,
  output reg [31:0] wb_pc4_o_debug
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wb_reg_we_o <= 1'h0;
    end
    else if (mem_pc4_i_debug[31]) begin
        // means this instruction is discard
        // we shouldn't write anything to the rf
        wb_reg_we_o <= 1'b0;
    end
    else begin
        wb_reg_we_o <= mem_reg_we_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wb_wD_o <= 1'h0;
    end
    else begin
        wb_wD_o <= mem_wD_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wb_wR_o <= 5'h0;
    end
    else begin
        wb_wR_o <= mem_wR_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wb_pc4_o_debug <= 5'h0;
    end
    else begin
        wb_pc4_o_debug <= mem_pc4_i_debug;
    end
end

endmodule