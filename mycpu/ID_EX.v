module ID_EX(
  input wire clk,
  input wire rst_n,

  input wire [1:0] id_pc_sel_i,
  input wire [1:0] id_reg_write_i,
  input wire id_mem_write_i,
  input wire id_branch_i,
  input wire id_alu_ctrl_i,
  input wire id_op_B_sel_i,
  input wire id_reg_we_i,
  input wire [31:0] id_opA_i,
  input wire [31:0] id_opB_i,
  input wire [31:0] id_rD2_i,
  input wire [31:0] id_ext_i,
  input wire [31:0] id_pc4_i,

  output reg [1:0] ex_pc_sel_o,
  output reg [1:0] ex_reg_write_o,
  output reg ex_mem_write_o,
  output reg ex_branch_o,
  output reg [3:0] ex_alu_ctrl_o,
  output reg ex_op_B_sel_o,
  output reg ex_reg_we_o,
  output reg [31:0] ex_opA_o,
  output reg [31:0] ex_opB_o,
  output reg [31:0] ex_rD2_o,
  output reg [31:0] ex_ext_o,
  output reg [31:0] ex_pc4_o
);


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_pc_sel_o <= 2'h0;
    end
    else begin
        ex_pc_sel_o <= id_pc_sel_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_reg_write_o <= 2'h0;
    end
    else begin
        ex_reg_write_o <= id_reg_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_mem_write_o <= 1'h0;
    end
    else begin
        ex_mem_write_o <= id_mem_write_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_branch_o <= 1'h0;
    end
    else begin
        ex_branch_o <= id_branch_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_alu_ctrl_o <= 4'h0;
    end
    else begin
        ex_alu_ctrl_o <= id_alu_ctrl_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_op_B_sel_o <= 1'h0;
    end
    else begin
        ex_op_B_sel_o <= id_op_B_sel_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_reg_we_o <= 1'h0;
    end
    else begin
        ex_reg_we_o <= id_reg_we_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_opA_o <= 32'h0;
    end
    else begin
        ex_opA_o <= id_opA_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_opB_o <= 32'h0;
    end
    else begin
        ex_opB_o <= id_opB_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_rD2_o <= 32'h0;
    end
    else begin
        ex_rD2_o <= id_rD2_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_ext_o <= 32'h0;
    end
    else begin
        ex_ext_o <= id_ext_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ex_pc4_o <= 32'h0;
    end
    else begin
        ex_pc4_o <= id_pc4_i;
    end
end




endmodule