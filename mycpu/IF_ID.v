module IF_ID(
  input wire clk,
  input wire rst_n,
  input wire [1:0] pipeline_stop_i,
  input wire [1:0] pipeline_stop_branch_i,

  input wire [31:0] if_pc4_i,
  input wire [31:0] if_inst_i,
  input wire if_debug_wb_have_inst,

  output reg [31:0] id_pc4_o,
  output reg [31:0] id_inst_o,
  output reg id_debug_wb_have_inst
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
        id_pc4_o <= id_pc4_o;
    end
    else if (pipeline_stop_branch_i) begin
        // give the pc a discard value
        id_pc4_o <= 32'hffff_ff00;
    end
    // else if (pipeline_stop_i && !pipeline_stop_first) begin
    //     pipeline_stop_first <= pipeline_stop_i;
    //     id_pc4_o <= id_pc4_o;
    // end
    // else if (pipeline_stop_first > 2'h1) begin
    //     pipeline_stop_first <= pipeline_stop_first + ~2'h1 + 1;
    //     id_pc4_o <= id_pc4_o;
    // end
    // else if (pipeline_stop_first == 2'h1) begin
    //     pipeline_stop_first <= 2'h0;
    //     id_pc4_o <= if_pc4_i;
    // end
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
    // else if (pipeline_stop_i && !pipeline_stop_first) begin
    //     id_inst_o <= id_inst_o;
    // end
    // else if (pipeline_stop_first > 2'h1) begin
    //     id_inst_o <= id_inst_o;
    // end
    else begin
        id_inst_o <= if_inst_i;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        id_debug_wb_have_inst <= 1'b0;
    end
    else if (start) begin
        id_debug_wb_have_inst <= 1'b0;
    end
    else if (pipeline_stop_i) begin
        id_debug_wb_have_inst <= id_debug_wb_have_inst;
    end
    else if (pipeline_stop_branch_i) begin
        id_pc4_o <= id_pc4_o;
    end
    // else if (pipeline_stop_i && !pipeline_stop_first) begin
    //     id_inst_o <= id_inst_o;
    // end
    // else if (pipeline_stop_first > 2'h1) begin
    //     id_inst_o <= id_inst_o;
    // end
    else begin
        id_debug_wb_have_inst <= if_debug_wb_have_inst;
    end
end
endmodule