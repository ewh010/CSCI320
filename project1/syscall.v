// Evan Harrington
// CSCI320
// Project 1 

//////////////// sycscall module ////////////////
module syscall(input syscallControl, input [31:0] v0, input [31:0] a0);
  always @(*) begin
    if(syscallControl == 1) begin
      if(v0 == 1) begin
        $display("\n\nTHIS IS THE SYSCALL OUTPUT = %d\n\n", a0);
      end
      else if(v0 == 10) begin
        $display("SYSCALL FOUND 10... ENDING EXECUTION\n");
        #1; $finish;
      end
    end
  end

endmodule
