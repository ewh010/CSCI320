module clock_gen(output reg clock);
initial
    clock = 1'b0;
always
begin
    #100; clock = ~clock;
    $display($time, " tick");
end
endmodule

module clockedAnd;
input clock
input a, b;
output reg c;

always @(posedge clock)
begin 
    c = a & b;
end

endmodule


// testbench
module test;

reg ain, bin;


wire clock;
clock_gen c(clock);
wire clockedAndOutput;
clockedAnd cAnd(clock, ain, bin, clockedAndOutput);

initial
begin
    $monitor ($time, " in %m, clock is: %d", clock);
    #1000; $finish;
end

endmodule
