// Evan Harrington
// CSCI320
// Project 1 

//////////////// Data Memory Module that takes inputs memWrite and Read/////////////////
module dataMem(input clock, input memWrite, input memRead, input [31:0] address, input [31:0] writeData, output reg [31:0] readData);
reg [31:0] memory[32'h7ffffffc >> 2: (32'h7ffffffc >> 2) - 256];
always @(*) begin
  if (memRead == 1)
    readData = memory[address >> 2];
end
always @(negedge clock) begin
  if(memWrite == 1)
    memory[address >> 2] = writeData;
end

endmodule
