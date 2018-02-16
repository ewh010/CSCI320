// Evan Harrington
// CSCI320
// Project 1 

////////// adder module: adds b to input a */
module adder(input [31:0] pcPlus4, input [31:0] signExtImmediate, output reg [31:0] out);

always @(*)
begin
  out = pcPlus4 + {signExtImmediate << 2};
end

endmodule