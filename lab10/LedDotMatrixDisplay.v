`define TimeExpire 32'd5000

module LedDotMatrixDisplay(rst, clk, dot_row, dot_col);
	input rst, clk;
	output [7:0] dot_row, dot_col;
	
	wire divclk;
	
	FrequencyDivider u_frequency_divider(
		.rst(rst),
		.clk(clk),
		.divclk(divclk)
	);
	
	DotMatrixDisplayController u_dot_matrix_display_controller(
		.rst(rst),
		.divclk(divclk),
		.dot_row(dot_row),
		.dot_col(dot_col)
	);

endmodule

module FrequencyDivider(rst, clk, divclk);
	input rst, clk;
	output reg divclk;
	
	reg [31:0] cnt;

   always @(posedge clk or negedge rst) begin
		if (~rst) begin
			cnt <= 32'd0;
			divclk <= 1'b0;
      end else begin
         if (cnt == `TimeExpire) begin 
				cnt <= 32'd0;
				divclk <= ~divclk;
			end else begin
				cnt <= cnt + 32'd1;
			end
      end
   end
	
endmodule 

module DotMatrixDisplayController(rst, divclk, dot_row, dot_col);
	input rst, divclk;
	output reg [7:0] dot_row, dot_col;
	
	reg [2:0]row_cnt;
	
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
			
			case (row_cnt)
				3'd0: dot_col <= 8'b00011000;
				3'd1: dot_col <= 8'b00100100;
				3'd2: dot_col <= 8'b01000010;
				3'd3: dot_col <= 8'b11000011;
				3'd4: dot_col <= 8'b01000010;
				3'd5: dot_col <= 8'b01000010;
				3'd6: dot_col <= 8'b01000010;
				3'd7: dot_col <= 8'b01111110;
			endcase
			
			row_cnt <= row_cnt + 1;
		end
	end
	
endmodule 