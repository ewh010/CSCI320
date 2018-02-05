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
module control(input [31:0] inst, output reg [10:0] outSignal);
	reg regDst;
  	reg jump;
  	reg branch;

  	reg memRead;
  	reg memToReg;

  	reg [2:0] ALUOp;
  	reg regWrite;   
  	reg ALUsrc;
  	reg memWrite;

  	initial
  	begin
    	regDst = 0;
    	jump = 0;
    	branch = 0;

    	memRead = 0;
    	memToReg = 0;

    	ALUOp = 3'b000;
    	regWrite = 0;   
    	ALUsrc = 0;
    	memWrit = 0;
  	end 
  	

	always @(inst) begin
  		$display ("opcode = ", inst[`op]);
  		$display ("functioncode= ", inst[`function]);
		
		//Jump Instructions
		case(inst[`op])
			`J || `JR ||`JAL:
			begin
				$display("This is a Jump instruction");
				6'h2: jumpOut =1;
				default: jumpOut = 0;
			end

		//R-Type Instructions	
			`SPECIAL:
			begin
				regWrite = 1; regDst =1;
				$display("This is an R-Type instruction");
				case(inst[`function])
				//And
          		6'b100100:
          			ALUOp = 3'b000;
          		//Or
          		6'b100101:
          			ALUOp = 3'b001;
				//Add 
				6'b100000: 
            		ALUOp = 3'b010;
          		//Sub
          		6'b100010:
          			ALUOp = 3'b110;
          		//slt
          		6'b101010:
          			ALUOp = 3'b111;
          		default:
          			$display("R-Type Error");
          		endcase
          	end
          	//ADDI and ORI
          	`ADDI || `ORI:
          	begin
          		$display("These are ADDI or ORI instructions");
          		regWrite =1; 
          		ALUOp = 3'b010; 
          		ALUsrc =1;
          	end
          	begin
          	//BEQ and BNE
          	`BEQ || `BNE:
          	begin
          		$display("These are BEQ or BNE instructions");
          		branch = 1; 
          		ALUop = 3'b110;
          	end
          	//Load Word
          	`LW:
          	begin
          		$display("This is a LW instruction");
          		memRead = 1; memToReg = 1;
          		ALUOp = 3'b010; 
          		ALUsrc = 1;
          		regWrite = 1; 
          	end
          	//Store Word
          	`SW:
          	begin
          		$display("This is a SW instruction");
          		ALUop = 3'b010; 
          		ALUsrc = 1;
          		memWrite = 1;
          	end

          	default:
          		$display("This command can't be completed");
    	endcase
    	signals = {regDst, jump, branch, memRead, memToReg, ALUOp, regWrite, ALUsrc, memWrite};
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
wire [10:0] outSignal;
reg clock = 0;
reg jumpOut = signals[9];

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
