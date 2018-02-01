/* Activity 5: Jump cont.
January 31, 2018
*/

`include "mips.h"

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
module add4 (input [31:0] currPC, output [31:0] PCplus4);
	assign PCplus4 = currPC + 4;
endmodule


///////////// Memory /////////////
module memory(input [31:0] currPC, output reg[31:0] inst); 
	reg [31:0] mem[30'h00100000:30'h00100003];	

	initial
	begin
		$readmemh("Jumps.in", mem);
	end

	always @(currPC) 
	begin
		inst = mem[currPC[31:2]];
		if (inst == 0) begin
			$finish;
		end
	end
endmodule

/////////////// Control /////////////
module control(input [31:0] inst, output reg jumpOut);

	initial
	begin
		jumpOut = 0;
	end
	always @(*) begin
		case(inst[31:26]) 
			6'h2: jumpOut =1;
			default: jumpOut = 0;
		
		case()
		endcase; 


	end

endmodule

/////////////// Calculate Jump Address
module calculateJumpAddress(input [31:0] PCplus4, input [31:0] inst, output wire [31:0] jumpAddr);
	assign jumpAddr = {PCplus4[31:28], inst[25:0] << 2};
endmodule
////////////// mux 2-to-1 ///////////
module mux2to1Bit(input jumpOut, input [31:0] jumpAddr, input [31:0] PCplus4, output reg [31:0] nextPC);
	always @(*)
	begin 
		if (jumpOut == 1)
			nextPC = jumpAddr;
		else
			nextPC = PCplus4;
	end

endmodule

//////////// TestBench /////////////
module testbench;
wire [31:0] nextPC;
wire [31:0] currPC;
wire [31:0] inst;
wire [31:0] jumpAddr;
wire [31:0] PCplus4;
wire jumpOut;


reg clock = 0;

pc testPC(clock, nextPC, currPC);
add4 adder(currPC, PCplus4);
memory mem(currPC, inst);
//calculateJumpAddress jumper(inst, PCplus4, jumpAddr);
assign jumpAddr = {PCplus4[31:28], inst[25:0] << 2};
control ctrl(inst, jumpOut);
mux2to1Bit mux(jumpOut,jumpAddr,PCplus4, nextPC);

always begin
	#1 clock = ~clock;
end 

initial
	begin
    	$dumpfile("testbench.vcd");
    	$dumpvars(0,testbench);

    	$monitor($time, "in %m, currPC %08x, nextPC = %08x, inst =%08x, jumpAddr =%08x, PCplus4 =%08x, jumpOut=%01x", currPC, nextPC, inst, jumpAddr, PCplus4, jumpOut);
    	#1000
		$finish;
	end
endmodule
