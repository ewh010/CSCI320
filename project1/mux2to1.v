// Evan Harrington
// CSCI320
// Project 1 

/////////////////////// Mux 2 to 1 ///////////////
module mux2to1(input select, input [31:0] muxIn1, input [31:0] muxIn2, output reg [31:0] muxOut);
always @(*) begin
  if (select == 0)
    muxOut = muxIn1;
  else
    muxOut = muxIn2;
end
endmodule

