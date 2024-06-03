module AdjustableRgbScreen(rst, clk, btn_r, btn_g, btn_b, h_sync, v_sync, vga_r, vga_g, vga_b);
	input rst, clk;
	input btn_r, btn_g, btn_b;
	output h_sync, v_sync;
	output [3:0] vga_r, vga_g, vga_b;
	wire divclk;
	
	FrequencyDivider u_frequency_divider(
		.rst(rst),
		.clk(clk),
		.divclk(divclk)
	);
	
	SyncCounter u_sync_counter(
		.rst(rst),
		.divclk(divclk),
		.h_sync(h_sync), 
		.v_sync(v_sync)
	);
	
	RgbControl u_rgb_control(
		.rst(rst), 
		.divclk(divclk), 
		.btn_r(btn_r), 
		.btn_g(btn_g), 
		.btn_b(btn_b), 
		.vga_r(vga_r), 
		.vga_g(vga_g), 
		.vga_b(vga_b)
	);

endmodule

module FrequencyDivider(rst, clk, divclk);
	input rst, clk;
	output divclk;
	
	reg divclk;
	reg [31:0] cnt;

   always @(posedge clk or negedge rst) begin
		if (~rst) begin
			cnt <= 32'd0;
			divclk <= 1'b0;
      end else begin
			if (cnt == 2) begin 
				cnt <= 32'd0;
				divclk <= ~divclk;
			end else begin
				cnt <= cnt + 32'd1;
			end
      end
   end
	
endmodule

module SyncCounter(rst, divclk, h_sync, v_sync);
	input rst, divclk;
	output h_sync, v_sync;
	
	reg h_sync = 1, v_sync = 1;
	reg [9:0] h_cnt, v_cnt;
	
	always @(posedge divclk or negedge rst) begin
		if (~rst) begin
			h_sync <= 1'b1;
			v_sync <= 1'b1;
			h_cnt <= 10'd0;
			v_cnt <= 10'd0;
      end else begin
			if (h_cnt == 639) begin
				h_cnt <= 10'd0;
				h_sync <= ~h_sync;
				h_sync <= 1;
				
				if (v_cnt == 479) begin
					v_cnt <= 10'd0;
					v_sync <= ~v_sync;
					v_sync <= 1;
				end else begin
					v_cnt <= v_cnt + 10'd1;
				end
			end else begin
				h_cnt <= h_cnt + 10'd1;
			end
      end
   end

endmodule 

module RgbControl(rst, divclk, btn_r, btn_g, btn_b, vga_r, vga_g, vga_b);
	input rst, divclk;
	input btn_r, btn_g, btn_b;
	output [3:0] vga_r, vga_g, vga_b;
	
	reg isClick = 0;
	reg [3:0] vga_r, vga_g, vga_b;
	
	always @(posedge divclk or negedge rst) begin
		if (~rst) begin
			isClick = 0;
			vga_r <= 4'b0;
			vga_g <= 4'b0;
			vga_b <= 4'b0;
      end else begin
			if (~isClick) begin
				if (btn_r) begin 
					vga_r <= vga_r + 4'b1;
					isClick <= 1;
				end
				
				if (btn_g) begin 
					vga_g <= vga_g + 4'b1;
					isClick <= 1;
				end
				
				if (btn_b) begin 
					vga_b <= vga_b + 4'b1;
					isClick <= 1;
				end
			end else begin 
				if (~btn_r && ~btn_g && btn_b) begin
					isClick <= 0;
				end
			end
      end
   end

endmodule 