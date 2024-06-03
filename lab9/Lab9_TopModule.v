`define TimeExpire 32'd50000000

module Lab9_TopModule(reset, in, clk, out);
    input reset;
	 input in;
	 input clk;
    wire divclk;
    wire [2:0] state;
    output [6:0] out;
    
    FrequencyDivider u_frequency_divider(
        .reset(reset),
        .clk(clk),
        .divclk(divclk)
    );

    MooreMachine u_moore_machine(
        .reset(reset),
		  .in(in),
        .divclk(divclk),
        .state(state)
    );

    SevenDisplay u_seven_display(
		  .state(state),
        .out(out)
    );

endmodule

module FrequencyDivider(reset, clk, divclk);
	input reset, clk;
	output reg divclk;
	
	reg [31:0] cnt;

   always @(posedge clk or negedge reset) begin
		if (!reset) begin
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

module MooreMachine(reset, in, divclk, state);
	input reset;
	input in;
	input divclk;
	output reg [2:0] state;
	reg [2:0] next_state;
	
	parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101;

	always @(posedge divclk or negedge reset) begin
		if (!reset) begin
			state <= s0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		case (state)
			s0: begin
				next_state = in ? s3 : s1;
			end
			s1: begin
				next_state = in ? s5 : s2;
			end
			s2: begin
				next_state = in ? s0 : s3;
			end
			s3: begin
				next_state = in ? s1 : s4;
			end
			s4: begin
				next_state = in ? s2 : s5;
			end
			s5: begin
				next_state = in ? s4 : s0;
			end
		endcase
	end

endmodule

module SevenDisplay(state, out);
	input [2:0] state;
	output reg [6:0] out;
	
	always @(*) begin
		case(state)
			3'b000: out = 7'b1000000;
			3'b001: out = 7'b1111001;
			3'b010: out = 7'b0100100;
			3'b011: out = 7'b0110000;
			3'b100: out = 7'b0011001;
			3'b101: out = 7'b0010010;
		endcase
	end 

endmodule 