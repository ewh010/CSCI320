// Evan Harrington
// CSCI320
// Project 1 


////////////////// Register Module which reads all registers and generates the Read Out Data /////////
module register(input clock, input jalControl, input[31:0] jalAddress, input [4:0] readRegister1, input [4:0] readRegister2, input [4:0] writeReg, input [31:0] writeData, input RegWrite, output reg [31:0] readData1, output reg [31:0] readData2, output wire [31:0] v0, output wire [31:0] a0, output wire [31:0] ra);

  reg [31:0] register[0:31];
  integer j;

  initial begin
    for(j = 0; j < 32; j = j+1)
      register[j] = 32'b0;
  end

  assign v0 = register[`v0];
  assign a0 = register[`a0];

  assign ra = register[`ra];

  always @(readRegister1, readRegister2) begin
    readData1 = register[readRegister1];
    readData2 = register[readRegister2];
  end

  always @(negedge clock) begin
    //$display("address in ra = %x", register[`ra]);
    if ((writeReg != `zero) & (RegWrite == 1)) begin
      if (jalControl == 1) begin
          $display("Writing to ra this value: %x", jalAddress);
          register[`ra] = jalAddress;
        end
      else begin
          if (writeReg != `ra)
            register[writeReg] = writeData;
        end
    end
  end
endmodule
