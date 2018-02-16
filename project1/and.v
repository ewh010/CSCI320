// Evan Harrington
// CSCI320
// Project 1 

////////////////// Operational And Gate ////////////////
module andOp(input branch, input Zero, output reg andOut);
always @(*) begin
  andOut = 0;
  if((branch == 1) & (Zero == 1))
    andOut = 1;
end

endmodule
