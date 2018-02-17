// Evan Harrington
// CSCI320
// Project 1 

////////////////// Get Jump Address Module /////////////////
module JumpAddr(input [31:0] inst, input [31:0] PCplus4, output wire [31:0] jumpAddr);

    assign jumpAddr = {PCplus4[31:28], inst[25:0] << 2};

endmodule
