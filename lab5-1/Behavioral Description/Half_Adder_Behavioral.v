module Half_Adder_Behavioral(a, b, sum, carry); 
	input a, b; 
	output sum, carry; 
	reg sum, carry; 
	
	always @(*) begin 
		sum = a ^ b; carry = a & b; 
	end 
	
endmodule 