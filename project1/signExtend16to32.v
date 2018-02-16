// Evan Harrington
// CSCI320
// Project 1 

/////////////////  Sign Extend Module 16 to 32 bits  /////////////////
module signExtend16to32(input[31:0] inst, output reg [31:0] outVal);
	always @(*) 
	begin
		if(inst[`op] == `ORI)
			outVal = {16'b0, inst[15:0]};
		else begin
			outVal = {{16{inst[15]}}, inst[15:0]};
		end
	end
endmodule