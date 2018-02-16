/*
Joshua Stough
CS320

I'm trying to test race conditions here. a clocked unit instigates a change in
some module A, which then instagates a change in module B, which goes back to A.
Looking for circular connectivity to see how many behavior blocks get executed
when one thing changes.
*/

module mod_A (input clk, input BtoA, output reg AtoB);
  reg [7:0] count;

  initial begin
    count = 0;
    AtoB = 0;
  end

  //When count becomes odd here is when the other behavior blocks in mod_A and
  //mod_B start playing with each other.
  always @ ( posedge clk ) begin
    count = count + 1;
    AtoB = count % 2;
    $display("\t%t: %m updated count %d and set AtoB %b", $time, count, AtoB);
  end

  always @ ( BtoA ) begin
    $display("\t%t: %m saw the change in BtoA %b at count %d", $time, BtoA, count);
    AtoB = 0; //~AtoB if you want to see an infinite loop at a single time step.
  end

endmodule // mod_A

module mod_B (input AtoB, output reg BtoA);
  initial begin
    BtoA = 0;
  end

  always @ ( AtoB ) begin
    $display("\t\t%t: %m saw the change in AtoB %b", $time, AtoB);
    BtoA = ~BtoA;
  end

endmodule // mod_B


module test ();

reg clk;
wire clkToA, AtoB, BtoA;

mod_A A(clk, BtoA, AtoB);
mod_B B(AtoB, BtoA);

initial begin
  clk = 1;
  //Initializing clk to 1 is perceived as a positive clock edge by the
  //relevant behavior in A. Try 0 to see the difference in the output
  //at time 0.

  $monitor($time, " in %m, clk %b, AtoB %b, BtoA %b.\n", clk, AtoB, BtoA);
  //$monitor($time, " in %m, AtoB %b, BtoA %b.\n", AtoB, BtoA);

  #201 $finish;
  //If you set this to #201, you can be assured that the action as time
  //200 is fully completed before the finish executes.
end

always begin
  #10 clk = ~clk;
end




endmodule // test


//always @(negativeedge clk);
//regWrite and ____

// alwas @posedge clk) begin
//if time == 0 begin
