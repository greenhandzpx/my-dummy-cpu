module EX_MEM(
  input wire clk,
  input wire rst_n,

  input wire [1:0] ex_reg_write_i,
  input wire [1:0] ex_mem_write_i,
  input wire ex_reg_we_i,
  input wire [31:0] ex_resC_i,
  input wire [31:0] ex_rD2_i,
  input wire [31:0] ex_ext_i,
  input wire [31:0] ex_pc4_i,

  output reg [1:0] mem_reg_write_o,
  output reg [1:0] mem_mem_write_o,
  output reg mem_reg_we_o,
  output reg [31:0] mem_resC_o,
  output reg [31:0] mem_rD2_o,
  output reg [31:0] mem_ext_o,
  output reg [31:0] mem_pc4_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_reg_write_o <= 2'h0;
    end
    else begin
        mem_reg_write_o <= ex_reg_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_mem_write_o <= 2'h0;
    end
    else begin
        mem_mem_write_o <= ex_mem_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_reg_we_o <= 1'h0;
    end
    else begin
        mem_reg_we_o <= ex_reg_we_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_resC_o <= 32'h0;
    end
    else begin
        mem_resC_o <= ex_resC_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_rD2_o <= 32'h0;
    end
    else begin
        mem_rD2_o <= ex_rD2_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_ext_o <= 32'h0;
    end
    else begin
        mem_ext_o <= ex_ext_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_pc4_o <= 32'h0;
    end
    else begin
        mem_pc4_o <= ex_pc4_i;
    end
end

endmodule