`define TimeExpire 32'd50000000

module UpDownCounter(reset, upDown, clk, out);
    input reset;
	 input upDown;
    input clk;
    wire div_clk;
    wire [3:0] cnt;
    output [6:0] out;
    
    FrequencyDivider u_frequency_divider(
        .reset(reset),
        .clock(clk),
        .div_clock(div_clk)
    );

    Counter u_counter(
        .reset(reset),
        .div_clock(div_clk),
        .up_down(upDown),
        .count(cnt)
    );

    SevenDisplay u_seven_display(
        .count(cnt),
        .out(out)
    );

endmodule

module FrequencyDivider(reset, clock, div_clock);
	input reset;
	input clock;
	output reg div_clock;
	
	reg [31:0] count;

   always @(posedge clock or negedge reset) begin
		if (!reset) begin
			count <= 32'd0;
			div_clock <= 1'b0;
      end else begin
         if (count == `TimeExpire) begin 
				count <= 32'd0;
				div_clock <= ~div_clock;
			end else begin
				count <= count + 32'd1;
			end
      end
   end
	
endmodule 

module Counter(reset, div_clock, up_down, count);
	input reset;
	input up_down;
	input div_clock;
	output reg [3:0] count;

	always @(posedge div_clock or negedge reset) begin
		if (!reset) begin
			count <= 4'b0000;
		end else begin
			if (up_down) begin
				count <= count + 1;
         end else begin
            count <= count - 1;
         end
		end 
	end

endmodule 

module SevenDisplay(count, out);
	input [3:0] count;
	output reg [6:0] out;
	
	always @(count) begin
		case (count)
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
			default: out = 7'b1000000;
		endcase 
	end 

endmodule 