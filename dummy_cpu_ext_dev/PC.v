module PC (
    input wire clk,
    input wire rst_n,
    input wire[31:0] npc,
    output reg[31:0] pc
//    output reg next_iter
);


reg [31:0] cnt;


reg start;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // when resetting, pc starts from 0
        pc <= 32'h0000_0000;
        cnt <= 32'h0;
//        next_iter <= 1'b1;
        start <= 1'b1;
    end
    else if (start == 1'b1) begin
        pc <= 32'h0000_0000;
        start <= 1'b0;
//        next_iter <= 1'b1;
    end
//    else if (cnt == 9999999) begin
//        cnt <= 32'h0;
//        pc <= npc;
//    end
    else begin
        pc <= npc;
//        cnt <= cnt + 1'b1;
//        next_iter <= 1'b1;
    end
    // else if (next == 1'b1) begin
    //     // else, pc is from npc
    //     // next_iter <= 1'b1;
    //     pc <= npc;
    //     cnt <= 3'h0;
    // end
    // else begin
    //     cnt <= cnt + 1'b1;
    //     next_iter <= 1'b0;
    // end
end

endmodule