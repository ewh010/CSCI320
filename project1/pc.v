// Evan Harrington
// CSCI320
// Project 1 

/////////////// PC Module /////////////////
module pc(input clock, input [31:0] nextPC, output reg [31:0] currPC);
initial begin
    currPC = 32'h00400020;
end

always @(posedge clock) begin
    if($time != 0)
    begin
  //  	$display("i am about the change to the next PC %31b", )
      currPC = nextPC;
    end
end

endmodule