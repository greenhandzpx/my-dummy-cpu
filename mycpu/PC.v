module PC (
    input wire clk,
    input wire rst_n,
    input wire[31:0] npc,
    input wire [1:0] pipeline_stop_i,
    input wire [1:0] pipeline_stop_branch_i,

    output reg[31:0] pc
    // output reg next_iter
);


reg [2:0] cnt;
wire next;
// pc change every 5 periods
assign next = cnt == 3'h4 ? 1'b1 : 1'b0;

reg start;
reg branch_first;

// reg [1:0] pipeline_stop_first;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // when resetting, pc starts from 0
        pc <= 32'h0000_0000;
        cnt <= 3'h0;
        branch_first <= 1'b1;
        // next_iter <= 1'b1;
        start <= 1'b1;
    end
    else if (start == 1'b1) begin
        pc <= 32'h0000_0000;
        start <= 1'b0;
        // next_iter <= 1'b1;
    end
    else if (pipeline_stop_i) begin
        // load-use hazard: freeze
        pc <= pc;
    end
    else if (pipeline_stop_branch_i) begin
        // control hazard: send a dirty(invalid) pc
        pc <= 32'hffff_ff00;
    end 
    // else if ((pipeline_stop_i || pipeline_stop_branch_i) && !pipeline_stop_first) begin
    //     pipeline_stop_first <= pipeline_stop_i > pipeline_stop_branch_i ? 
    //                             pipeline_stop_i : pipeline_stop_branch_i;
    //     pc <= pc;
    // end
    // else if (pipeline_stop_first > 2'h1) begin
    //     pipeline_stop_first <= pipeline_stop_first + ~2'h1 + 1;
    //     pc <= pc;
    // end
    // else if (pipeline_stop_first == 2'h1) begin
    //     pipeline_stop_first <= 2'h0;
    //     pc <= npc;
    // end
    else begin
        // branch_first <= 1'b1;
        pc <= npc;
        // next_iter <= 1'b1;
    end

end

endmodule