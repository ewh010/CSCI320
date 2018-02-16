// Evan Harrington
// CSCI320
// Project 1 

////////////// Add4 module /////////////
module add4 (input [31:0] currPC, output [31:0] PCplus4);
	assign PCplus4 = currPC + 4;
endmodule

////////// adder module: adds b to input a //////////
module adder(input [31:0] PCplus4, input [31:0] signExtImmediate, output reg [31:0] out);

always @(*) begin
  out = PCplus4 + {signExtImmediate << 2};
end

endmodule