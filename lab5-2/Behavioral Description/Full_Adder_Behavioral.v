module Full_Adder_Behavioral(a, b, c_in, sum, c_out);
	input a, b, c_in;
	output sum, c_out;
	reg sum, c_out;
	
	always @(*) begin 
		sum = (a ^ b) ^ c_in;
		c_out = a & b | (a ^ b) & c_in;
	end 

endmodule 
		