module EX_MEM(
  input wire clk,
  input wire rst_n,
  input wire pipeline_stop_i,

  input wire [1:0] ex_reg_write_i,
  input wire [1:0] ex_mem_write_i,
  input wire ex_reg_we_i,
  input wire [31:0] ex_resC_i,
  input wire [31:0] ex_rD2_i,
  input wire [31:0] ex_ext_i,
  input wire [31:0] ex_pc4_i,
  input wire [4:0] ex_wR_i,
  input wire ex_debug_wb_have_inst_i,

  output reg [1:0] mem_reg_write_o,
  output reg [1:0] mem_mem_write_o,
  output reg mem_reg_we_o,
  output reg [31:0] mem_resC_o,
  output reg [31:0] mem_rD2_o,
  output reg [31:0] mem_ext_o,
  output reg [31:0] mem_pc4_o,
  output reg [4:0] mem_wR_o,
  output reg mem_debug_wb_have_inst_o
);
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_reg_write_o <= 2'h0;
    end
    else if (pipeline_stop_i) begin
        mem_reg_write_o <= mem_reg_write_o;
    end
    else begin
        mem_reg_write_o <= ex_reg_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_mem_write_o <= 2'h0;
    end
    else if (pipeline_stop_i) begin
        mem_mem_write_o <= mem_mem_write_o;
    end
    else begin
        mem_mem_write_o <= ex_mem_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_reg_we_o <= 1'h0;
    end
    else if (pipeline_stop_i) begin
        mem_reg_we_o <= mem_reg_we_o;
    end
    else begin
        mem_reg_we_o <= ex_reg_we_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_resC_o <= 32'h0;
    end
    else if (pipeline_stop_i) begin
        mem_resC_o <= mem_resC_o;
    end
    else begin
        mem_resC_o <= ex_resC_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_rD2_o <= 32'h0;
    end
    else if (pipeline_stop_i) begin
        mem_rD2_o <= mem_rD2_o;
    end
    else begin
        mem_rD2_o <= ex_rD2_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_ext_o <= 32'h0;
    end
    else if (pipeline_stop_i) begin
        mem_ext_o <= mem_ext_o;
    end
    else begin
        mem_ext_o <= ex_ext_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_pc4_o <= 32'h0;
    end
    else if (pipeline_stop_i) begin
        mem_pc4_o <= mem_pc4_o;
    end
    else begin
        mem_pc4_o <= ex_pc4_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_wR_o <= 5'h0;
    end
    else if (pipeline_stop_i) begin
        mem_wR_o <= mem_wR_o;
    end
    else begin
        mem_wR_o <= ex_wR_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_debug_wb_have_inst_o <= 1'h0;
    end
    else if (pipeline_stop_i) begin
        mem_debug_wb_have_inst_o <= mem_debug_wb_have_inst_o;
    end
    else begin
        mem_debug_wb_have_inst_o <= ex_debug_wb_have_inst_i;
    end
end

endmodule