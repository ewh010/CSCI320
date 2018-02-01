/* Activity 2:Min/Max/Mean 
Worked With: Matt Lenk, Ryan Pencak
January 21, 2018
*/


//////////////////////////// Min //////////////////////////////////////
module min(input[31:0] a,input[31:0] b, output wire[31:0] out);
	/*assign out = (a<b) ? a:b; another way to do this*/
	reg [31:0] smaller;

	always @(*)
		begin
			if (a<b)
				smaller = a;
			else
				smaller = b;
		end
	assign out = smaller;
endmodule

//////////////////////////// Max ///////////////////////////////////////
module max(input[31:0] a,input[31:0] b, output wire[31:0] out);
	reg [31:0] larger;
	always @(*)
		begin
			if (a>b)
				larger = a;
			else
				larger = b;
		end
	assign out = larger;
endmodule

/////////////////////////// Mean ///////////////////////////////////////
module mean(input[31:0] a,input[31:0] b, output wire[31:0] out);
	reg [31:0] average;
	always @(*)
		begin
			average = (a + b)/2;
		end
	assign out = average;
endmodule



//////////////////////// TestBench Min //////////////////////////////////
module testbench;
reg [31:0] a;
reg [31:0] b;
wire [31:0] outputMin;
wire [31:0] outputMax;
wire [31:0] outputMean;

min minimum(a, b, outputMin);
max maximum(a, b, outputMax);
mean mean1(a, b, outputMean);

initial
begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);

    a = 6; b = 12;
    $monitor("a = %d, b = %d, Minimum = %d, Maximum = %d, Mean = %d", a, b, outputMin, outputMax, outputMean); 
    #20 a = 18; b = 12;
    #40 a = 12; b = 24;
    #100; $finish;
end


endmodule

