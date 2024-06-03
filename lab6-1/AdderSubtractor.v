module AdderSubtractor(a, b, select, out, overflow);
	input [3:0] a;
	input [3:0] b;
	input select;
	output reg [3:0] out;
	output reg overflow;
	
	reg [4:0] temp;
	
	always @(*) begin
		if (select) begin
			temp = {1'b0, a} + {1'b0, b};
		end
		else begin
			temp = {1'b0, a} - {1'b0, b};
		end
		out = temp [3:0];
		overflow = temp [4];
	end
	
endmodule 	