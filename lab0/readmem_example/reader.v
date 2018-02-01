/*
  module memory

  Implements a 32-bit big-endian memory block. The address is initalized at 0
  and for each postive clock edge, the current address is incremented. The
  addressed memory word is output on "out". Data is read from the file
  'mem.in'.
*/
module memory (input clock, output wire [31:0] out);

///////////////////////// internal memory storage //////////////////////////////
reg [31:0] mem[3:0];  // store 4 32-bit words.
reg [1:0] addr;       // internal address


//////////////////////////////// initial ///////////////////////////////////////
initial
begin
  $readmemh("mem.in", mem);
  addr = 0;                           // memory starting address
end

assign
  out = mem[addr]; // continuous assignment for output

always @(posedge clock)
  addr ++;        // increment address

endmodule
////////////////////////// endmodule memory ////////////////////////////////////


/*
  module testbench -- for testing clocked memory module
 */
module testbench;
reg clock;                  // testbench clock
wire [31:0] memout;         // currently addressed word.
memory mem(clock, memout);  // create the memory

initial
begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);

    clock = 0;
    $monitor($time, ": addr = %08x, mem[addr] = %08x", mem.addr, memout);
    #100; $finish;
end

always
  begin                     // inline clock generator
    #10; clock = ~clock;
  end
endmodule
