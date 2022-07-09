module IF_ID(
  input wire clk,
  input wire rst_n,
  input wire pipeline_stop_i,
  input wire pipeline_stop_branch_i,

  input wire [31:0] if_pc4_i,
  input wire [31:0] if_inst_i,

  output reg [31:0] id_pc4_o,
  output reg [31:0] id_inst_o
);

reg start;

reg [1:0] pipeline_stop_first;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        id_pc4_o <= 31'h0;
        start <= 1'b1;
        pipeline_stop_first <= 2'h0;
    end
    else if (start) begin
        id_pc4_o <= 31'h0;
        start <= 1'b0;
    end
    else if (pipeline_stop_i) begin
        // load-use hazard: just keep the original pc 
        id_pc4_o <= id_pc4_o;
    end
    else if (pipeline_stop_branch_i) begin
        // control hazard: give the pc an invalid value
        id_pc4_o <= 32'hffff_ff00;
    end
    else begin
        id_pc4_o <= if_pc4_i;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        id_inst_o <= 31'h0;
    end
    else if (start) begin
        id_inst_o <= 31'h0;
    end
    else if (pipeline_stop_i) begin
        id_inst_o <= id_inst_o;
    end
    else if (pipeline_stop_branch_i) begin
        id_pc4_o <= id_pc4_o;
    end
    else begin
        id_inst_o <= if_inst_i;
    end
end

endmodule