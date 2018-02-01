/* Activity 3: PC/Adder/Memory 
January 21, 2018
*/

//////////// PC //////////////
module pc(input clock, input [31:0] nextPC, output reg[31:0] currPC);

initial
begin
	currPC = 32'h00400000;
end

always @(posedge clock) begin
	currPC <= nextPC;
end
endmodule


///////////// adder /////////////
module add4 (input [31:0] a, output [31:0] outval);
	assign outval = a + 4;
endmodule


///////////// Memory /////////////
module memory(input [31:0] inAddr, output reg[31:0] dataOut); 
	reg [31:0] mem[29'h00100000:29'h00100003];	

	initial
	begin
		$readmemh("mem.in", mem);
	end

	always @(inAddr) 
	begin
		dataOut = mem[inAddr[31:2]];
		if (dataOut == 0) begin
			$finish;
		end
	end
endmodule
//////////// TestBench /////////////
module testbench;
wire [31:0] nextPC;
wire [31:0] currPC;
wire [31:0] memOut;

reg clock = 0;

pc testPC(clock, nextPC, currPC);
add4 adder(currPC, nextPC);
memory mem(currPC, memOut);

always begin
	#1 clock = ~clock;
end 

initial
	begin
    	$dumpfile("testbench.vcd");
    	$dumpvars(0,testbench);

    	$monitor("in %m, currPC %08x, nextPC = %08x, memOut =%08x", currPC, nextPC, memOut);
    	#100 
		$finish;
	end
endmodule

