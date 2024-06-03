module SpecialFuncMultiplier(in,out);
	input [3:0] in;
	output reg [6:0] out;
	
	always @(*) begin
		case (in) 
			0: out = 7'b1000000;
			1: out = 7'b1111001;
			2: out = 7'b0100100;
			3: out = 7'b1111000;
			4: out = 7'b0010000;
			5: out = 7'b0000011;
			6: out = 7'b0000011;
			7: out = 7'b0100001;
			8: out = 7'b0001110;
			default: out = 7'b1000000;
		endcase 
	end
	
endmodule 