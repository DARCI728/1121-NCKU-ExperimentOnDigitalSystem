module TrafficLightSystem(rst, clk, dot_row, dot_col, out);
	input rst, clk;
	wire divclk_1Hz, divclk_10000Hz;
	wire [1:0] state;
	wire [3:0] cnt;
	output [7:0] dot_row, dot_col;
	output [6:0] out;
	
	FrequencyDivider u_frequency_divider(
		.rst(rst),
		.clk(clk),
		.divclk_1Hz(divclk_1Hz),
		.divclk_10000Hz(divclk_10000Hz)
	);
	
	TrafficLightFSM u_traffic_light_fsm(
		.rst(rst),
		.divclk_1Hz(divclk_1Hz),
		.divclk_10000Hz(divclk_10000Hz),
		.state(state),
		.cnt(cnt)
	);
	
	DotMatrixDisplay u_dot_matrix_display(
		.rst(rst),
		.divclk(divclk_10000Hz),
		.state(state),
		.dot_row(dot_row),
		.dot_col(dot_col)
	);
	
	SevenDisplay u_seven_display(
		.cnt(cnt),
		.out(out)
	);
	
endmodule 

module FrequencyDivider(rst, clk, divclk_1Hz, divclk_10000Hz);
	input rst, clk;
	output reg divclk_1Hz, divclk_10000Hz;
	
	reg [31:0] cnt_1Hz, cnt_10000Hz;

   always @(posedge clk or negedge rst) begin
		if (~rst) begin
			cnt_1Hz <= 32'd0;
			cnt_10000Hz <= 32'd0;
			divclk_1Hz <= 1'b0;
			divclk_10000Hz <= 1'b0;
      end else begin
         if (cnt_1Hz == 50000000) begin 
				cnt_1Hz <= 32'd0;
				divclk_1Hz <= ~divclk_1Hz;
			end else begin
				cnt_1Hz <= cnt_1Hz + 32'd1;
			end
			
			if (cnt_10000Hz == 5000) begin 
				cnt_10000Hz <= 32'd0;
				divclk_10000Hz <= ~divclk_10000Hz;
			end else begin
				cnt_10000Hz <= cnt_10000Hz + 32'd1;
			end
      end
   end
	
endmodule 

module TrafficLightFSM(rst, divclk_1Hz, divclk_10000Hz, state, cnt);
	input rst, divclk_1Hz, divclk_10000Hz;
	output reg [1:0] state;
	output reg [3:0] cnt;
	reg [1:0] next_state;
	reg [3:0] next_cnt;
	
	parameter green = 2'b00, yellow = 2'b01, red = 2'b10;
	
	always @(posedge divclk_1Hz or negedge rst) begin
		if (~rst) begin
			cnt <= 4'd10;
		end else begin
			if (cnt == 4'd0) begin
				cnt <= next_cnt;
			end else begin
				cnt <= cnt - 4'd1;
			end
		end
	end

	always @(posedge divclk_10000Hz or negedge rst) begin
		if (~rst) begin
			state <= green;
		end else begin
			if (cnt == 4'd0) begin
				state <= next_state;
			end
		end
	end

	always @(*) begin
		case (state)
			green: begin 
				next_state = yellow;
				next_cnt = 4'd3;
			end
			yellow: begin 
				next_state = red;
				next_cnt = 4'd15;
			end
			red: begin 
				next_state = green;
				next_cnt = 4'd10;
			end
		endcase
	end
 
endmodule 

module DotMatrixDisplay(rst, divclk, state, dot_row, dot_col);
	input rst, divclk;
	input [1:0] state;
	output reg [7:0] dot_row, dot_col;
	reg [2:0]row_cnt;
	
	parameter green = 2'b00, yellow = 2'b01, red = 2'b10;
	
	always @(posedge divclk or negedge rst) begin
		if (~rst) begin
			dot_row <= 8'd0;
			dot_col <= 8'd0;
			row_cnt <= 3'd0;
		end else begin
			case (row_cnt)
				3'd0: dot_row <= 8'b01111111;
				3'd1: dot_row <= 8'b10111111;
				3'd2: dot_row <= 8'b11011111;
				3'd3: dot_row <= 8'b11101111;
				3'd4: dot_row <= 8'b11110111;
				3'd5: dot_row <= 8'b11111011;
				3'd6: dot_row <= 8'b11111101;
				3'd7: dot_row <= 8'b11111110;
			endcase
		
			if (state == green) begin 
				case (row_cnt)
					3'd0: dot_col <= 8'b00001100;
					3'd1: dot_col <= 8'b00001100;
					3'd2: dot_col <= 8'b00011001;
					3'd3: dot_col <= 8'b01111110;
					3'd4: dot_col <= 8'b10011000;
					3'd5: dot_col <= 8'b00011000;
					3'd6: dot_col <= 8'b00101000;
					3'd7: dot_col <= 8'b01001000;
				endcase
			end
			
			if (state == yellow) begin
				case (row_cnt)
					3'd0: dot_col <= 8'b00000000;
					3'd1: dot_col <= 8'b00100100;
					3'd2: dot_col <= 8'b00111100;
					3'd3: dot_col <= 8'b10111101;
					3'd4: dot_col <= 8'b11111111;
					3'd5: dot_col <= 8'b00111100;
					3'd6: dot_col <= 8'b00111100;
					3'd7: dot_col <= 8'b00000000;
				endcase
			end
			
			if (state == red) begin
				case (row_cnt)
					3'd0: dot_col <= 8'b00011000;
					3'd1: dot_col <= 8'b00011000;
					3'd2: dot_col <= 8'b00111100;
					3'd3: dot_col <= 8'b00111100;
					3'd4: dot_col <= 8'b01011010;
					3'd5: dot_col <= 8'b00011000;
					3'd6: dot_col <= 8'b00011000;
					3'd7: dot_col <= 8'b00100100;
				endcase
			end
			
			row_cnt <= row_cnt + 1;
		end
	end
	
endmodule 

module SevenDisplay(cnt, out);
	input [3:0] cnt;
	output reg [6:0] out;
	
	always @(*) begin
		case (cnt)
			4'b0000: out = 7'b1000000;
			4'b0001: out = 7'b1111001;
			4'b0010: out = 7'b0100100;
			4'b0011: out = 7'b0110000;
			4'b0100: out = 7'b0011001;
			4'b0101: out = 7'b0010010;
			4'b0110: out = 7'b0000010;
			4'b0111: out = 7'b1111000;
			4'b1000: out = 7'b0000000;
			4'b1001: out = 7'b0010000;
			4'b1010: out = 7'b0001000;
			4'b1011: out = 7'b0000011;
			4'b1100: out = 7'b1000110;
			4'b1101: out = 7'b0100001;
			4'b1110: out = 7'b0000110;
			4'b1111: out = 7'b0001110;
		endcase 
	end 

endmodule 