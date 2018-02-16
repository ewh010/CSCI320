// Evan Harrington
// CSCI320
// Project 1 

///////////////  Multiplexor Mux Module //////////////
module mux5bit(input select, input [4:0] muxIn1, input [4:0] muxIn2, output reg [4:0] muxOut);
always @(*)begin
  if (select == 0)
    muxOut = muxIn1;
  else
    muxOut = muxIn2;
end

endmodule
