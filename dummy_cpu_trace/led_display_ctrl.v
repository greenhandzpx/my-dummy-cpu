module LED_DISPLAY (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	
	input  wire[31:0] res_data,
	
	output reg  [7:0] led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
);
reg dp;
assign led_dp = dp;
wire rst_n = ~ rst;
reg cnt_inc = 1'b0;
reg [31: 0] cnt = 32'b0;
wire cnt_end = cnt_inc & (cnt == 32'd100000000);
parameter N = 10; // 控制倒计时计数器
parameter N2 = 2; // 控制不同的灯在同一时间亮的频率
reg [23:0] cnt2 = 24'b0;
reg [15: 0] din_timer = 16'b1001111100000011; // 初始化为10
reg [3: 0] timer = 4'b1010; // 初始化为10s
reg button2 = 1'b0;

//always @(posedge clk or negedge rst_n) begin
//    if(~rst_n) 
//        cnt_inc <= 1'b0;
//    else if(button)
//        cnt_inc <= 1'b1;
//    else if(cnt_end)
//        cnt_inc <= 1'b0;
//end

//always @(posedge clk or negedge rst_n) begin
//    if(~rst_n) 
//        cnt <= 32'b0;
//    else if(cnt_end)
//        cnt <= 32'b0;
//    else if(cnt_inc)
//        cnt <= cnt + 1'b1;
//end

always @(posedge clk or negedge rst) begin
	if(rst) begin // 复位
		button2 <= 1'b0;
		{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b1111111;
        dp <= 1'b1;
        timer <= 4'b1010;
        din_timer <= 16'b1001111100000011;
        cnt <= 32'b0;
    end
	else if(button || button2) begin 
		if(button2 == 1'b0) begin // 启动
			button2 <= button;
			led_en <= 8'b11111110;
			{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0010010;
            dp <= 1;
		end
    
		else if(cnt2 == N2) begin
            cnt2 <= 24'b0;
                led_en <= {led_en[6: 0], led_en[7]};
                case (led_en)
                    8'b01111111: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0010010; // 2
                    8'b11111110: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0010010; // 2
                    8'b11111101: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0100100; // 5
                    8'b11111011: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b1001111; // 1
                    8'b11110111: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0000001; // 0
                    8'b11101111: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b0010010; // 2
                    8'b11011111: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= din_timer[7: 1]; // 个位
                    8'b10111111: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= din_timer[15: 9]; // 十位
                    default: {led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} <= 7'b1111111;
                endcase
	    end
	    else
	       cnt2 <= cnt2 + 1'b1;
        if(cnt == N) begin
            cnt <= 32'b0;
			if(timer == 4'b0000) begin
				timer <= 4'b1010;
			end
			else
				timer <= timer - 4'b0001;
			case (timer)
				4'b0000: din_timer <= 16'b1001111100000011;  // 1 0
				4'b1010: din_timer <= 16'b0000001100011001;  // 0 9
				4'b1001: din_timer <= 16'b0000001100000001;  // 0 8
				4'b1000: din_timer <= 16'b0000001100011111;  // 0 7
				4'b0111: din_timer <= 16'b0000001101000001;  // 0 6
				4'b0110: din_timer <= 16'b0000001101001001;  // 0 5
				4'b0101: din_timer <= 16'b0000001110011001;  // 0 4
				4'b0100: din_timer <= 16'b0000001100001101;  // 0 3
				4'b0011: din_timer <= 16'b0000001100100101;  // 0 2
				4'b0010: din_timer <= 16'b0000001110011111;  // 0 1
				4'b0001: din_timer <= 16'b0000001100000011;  // 0 0
			endcase
	   end
	   else
	       cnt <= cnt + 1'b1;
    end
end
endmodule