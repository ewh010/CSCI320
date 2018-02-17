// Evan Harrington
// CSCI320
// Project 1 
module alu(input [31:0] data1, input [31:0] data2, input [2:0] ALUOp, output reg [31:0] ALUResult, output reg Zero);
  always @(*) begin
    case(ALUOp)
      //AND
      3'b000:
        ALUResult = data1 & data2;
      //OR
      3'b001: 
        ALUResult = data1 | data2;
      //ADD
      3'b010: 
        ALUResult = data1 + data2;
      //SUB
      3'b110: 
        ALUResult = data1 - data2;
      //LUI
      3'b011: 
        ALUResult = {data2, 16'b0};
      //SLT
      3'b111: 
      begin
        if(data1 < data2)
          ALUResult = 1;
        else
          ALUResult = 0;
      end
    endcase
    // $display("ALU RESULT: %d", ALUresult);
    Zero = (ALUResult == 0) ? 1:0;
  end
endmodule 