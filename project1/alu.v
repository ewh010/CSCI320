// Evan Harrington
// CSCI320
// Project 1 
module alu(input [31:0] data1, input [31:0] data2, input [2:0] ALUOp, output reg [31:0] address, output reg Zero);
always @(*) begin
  // And //
  if (ALUOp == 3'b000)begin
    address = data1 & data2;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end
  // Or //
  if (ALUOp == 3'b001) begin
    address = data1 | data2;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end

  // Add //
  if (ALUOp == 3'b010)begin
    address = data1+data2;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end  

  //Sub//
  if (ALUOp == 3'b110)begin
    address = data1 - data2;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end

  // SLT // 
  if (ALUOp == 3'b111) begin
    if (data1 < data2)begin
      Zero = 1'b1;
    end
    if (data2 < data1)begin
      Zero = 1'b0;
    end
  end
end

endmodule 