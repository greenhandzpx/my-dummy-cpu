module MEM_WB(
  input wire clk,
  input wire rst_n,

  input wire mem_reg_we_i,
  input wire [31:0] mem_wD_i,

  output reg wb_reg_we_o,
  output reg [31:0] wb_wD_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wb_reg_we_o <= 1'h0;
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

endmodule