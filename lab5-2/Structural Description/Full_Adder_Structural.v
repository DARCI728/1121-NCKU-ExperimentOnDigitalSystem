module Full_Adder_Structural(a, b, c_in, sum, c_out);
	input a, b, c_in;
	output sum, c_out;
	
	wire [2:0] W;
	
	xor xor1(W[0], a, b);
	xor xor2(sum, W[0], c_in);
	and and1(W[1], a, b);
	and and2(W[2], W[0], c_in);
	or or1(c_out, W[1], W[2]);
	
endmodule 