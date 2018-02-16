/* Activity 5: Jump cont.
January 31, 2018
*/

`include "mips.h"

//////////// PC //////////////
module pc(input clock, input [31:0] nextPC, output reg[31:0] currPC);

initial
begin
	currPC = 32'h00400020;
end

always @(posedge clock)
begin
	if($time !=0)
    currPC <= nextPC;
end
endmodule


///////////// adder /////////////
module add4 (input [31:0] currPC, output [31:0] PCplus4);
	assign PCplus4 = currPC + 4;
endmodule


///////////// Memory /////////////
module memory(input [31:0] currPC, output reg[31:0] inst); 
	reg [31:0] mem[29'h00100000:29'h00100100];	

	initial 
  begin
		$readmemh("add_test.v", mem);
	end

	always @(currPC) 
	begin
		inst = mem[currPC[31:2]];
/*		if (inst == 0) begin
			$finish;
		end*/
	end
endmodule

/////////////// Calculate Jump Address /////////////////
module calculateJumpAddress(input [31:0] inst, input [31:0] PCplus4, output wire [31:0] jumpAddr);
  assign jumpAddr = {PCplus4[31:28], inst[25:0] << 2};
endmodule

/////////////// Control /////////////
module control(input [31:0] inst, output reg syscall, output reg [10:0] signals);
  reg regDst;
  reg jump;
  reg branch;
  
  reg memRead;
  reg memToReg;
  reg [2:0] ALUop;
    
  reg regWrite;   
  reg ALUsrc;
  reg memWrite;

	always @(inst) begin
    regDst = 0;
    jump = 0;
    branch = 0;

    memRead = 0;
    memToReg = 0;

    ALUop = 3'b000;
    regWrite = 0;   
    ALUsrc = 0;
    memWrite = 0;

//  		$display ("opcode = ", inst[`op]);
//  		$display ("functioncode= ", inst[`function]);
		
		//Jump and Jump and Link Instructions
/*		case(inst[`op])
			`J ,`JAL:
			begin
				$display("This is a Jump or Jump and Link instruction");
				jump =1;
//				default: jumpOut = 0;
			end

		//R-Type Instructions	
			`SPECIAL:
			begin
				regWrite = 1; regDst =1;
				$display("This is an R-Type instruction");
				case(inst[`function])
          //And and Or
					`AND: begin 
          	ALUOp = 3'b000;
          end
          `OR: begin
          	ALUOp = 3'b001;
					end
          //Add and Subtract
					`ADD: begin 
            ALUOp = 3'b010;
          end
          `SUB: begin
          	ALUOp = 3'b110;
          end
          `SLT: begin
          	ALUOp = 3'b111;
          end
          //Jump Register
          `JR: begin
            $display("This is a JR instruction");
            jump = 1; regWrite =1;
          end 
          //NOP
          6'b000000:
            $display("This is a NOP");

          `SYSCALL: begin
            $display("This is a SYSCALL");
            regDst = 0; jump = 0; branch = 0;memRead = 0; memToReg = 0; ALUOp = 3'b00; regWrite=0; memWrite=0; syscall = 1;
          end
          default:
          	$display("This is an R-Type Error");
        endcase
      end
          	//ADDI and ORI
          	`ADDI ||`ORI:
          	begin
          		$display("These are ADDI or ORI instructions");
          		regWrite =1; 
          		ALUOp = 3'b010; 
          		ALUsrc =1;
          	end       
          	//BEQ and BNE
          	`BEQ ||`BNE:
          	begin
          		$display("These are BEQ or BNE instructions");
          		branch = 1; 
          		ALUOp = 3'b110;
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
          		ALUOp = 3'b010;
              ALUsrc = 1;
              regWrite =1;
          	end

          	default:
          		$display("This command can't be completed");
    	endcase

      //$monitor()
    	signals = {regDst, jump, branch, memRead, memToReg, ALUOp, regWrite, ALUsrc, memWrite};
	end

endmodule
*/

case (instr[`op])
      `J, `JAL: begin
        $display("jump instruction");
        jump = 1;
      end
      `SPECIAL: begin
        regDst = 1; regWrite = 1; 
        case (instr[`function])
          `ADD: begin
      $display("Add");
            ALUop = 3'b010;
    end
          `OR: begin
      $display("Or");
            ALUop = 3'b001;
    end
          `AND: begin
      $display("And");
            ALUop = 3'b000;
    end
          `SUB: begin
      $display("Sub");
            ALUop = 3'b110;
    end
          `SLT: begin 
      $display("Slt");
            ALUop = 3'b111;
    end
    `JR: begin
      $display("Jump Register");
      jump = 1; regWrite = 1;
    end
    6'b000000: // nop
      $display("nop");
    `SYSCALL: begin
      $display("Syscall");
            regDst = 0; jump = 0; branch = 0; memRead = 0; memToReg = 0; ALUop = 3'b000; regWrite = 0; ALUsrc = 0; memWrite = 0; syscall = 1;
          end
          default:
            $display("R-type not yet completed\n");
        endcase
      end
      `BEQ, `BNE:
      begin
        $display("BEQ or BNE instruction");
        branch = 1; ALUop = 3'b110;
      end
      `ADDIU, `ADDI:
      begin
        $display("ADDI or ADDIU instruction");
        regWrite = 1; ALUop = 3'b010; ALUsrc = 1;
      end
      `LW:
      begin
        $display("LW instruction");
        memRead = 1; memToReg = 1; ALUop = 3'b010; regWrite = 1; ALUsrc = 1;
      end
      `SW:
      begin
        $display("SW instruction");
        ALUop = 3'b010; ALUsrc = 1; memWrite = 1;
      end
      default:
        $display("Command has not been completed\n");
    endcase
  
    signals = {regDst, jump, branch, memRead, memToReg, ALUop, regWrite, ALUsrc, memWrite};
  
  end
endmodule





////////////// mux 2-to-1 ///////////
module mux2to1Bit(input controlSignal, input [31:0] input0, input [31:0] input1, output reg [31:0] muxOut);
  always @(*)
  begin 
    if (controlSignal == 0)
      muxOut = input0;
    else
      muxOut = input1;
  end

endmodule

///////////// register mux /////////////
module registerMux(input controlSignal, input [4:0] input1, input [4:0] input2, output reg [4:0] muxOut);
always @(*)
begin
  if (controlSignal == 0)
    muxOut = input1;
  else
    muxOut = input2;
end
endmodule

/////////////// ALU //////////////////
/*module ReadDataALU(input [31:0] readData1, input [31:0] signExtend, input [2:0] ALUOp, output reg [31:0] address, output reg Zero);
always @(readData1 or signExtend or ALUOp) begin
  // And //
  if (ALUOp == 3'b000)begin
    address = readData1 & signExtend;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end
  // Or //
  if (ALUOp == 3'b001) begin
    address = readData1 | signExtend;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end

  // Add //
  if (ALUOp == 3'b010)begin
    address = readData1+signExtend;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end  

  //Sub//
  if (ALUOp == 3'b110)begin
    address = readData1 - signExtend;
    if (address == 32'h0000)begin
      Zero = 1'b1;
    end
    else begin
      Zero = 1'b0;
    end
  end

  // SLT // 
  if (ALUOp == 3'b111) begin
    if (readData1 < readData2)begin
      Zero = 1'b1;
    end
    if (readData2 < readData1)begin
      Zero = 1'b0;
    end
  end
end

endmodule
*/


module alu(input [31:0] data1, input [31:0] data2, input [2:0] aluOp, output reg [31:0] address, output reg zero);

// output zero can be a continuous result where the ALU result == 0

always @(*)
begin
  // make this a case statement
  case (aluOp)
  3'b000:
    address = data1 & data2;
  3'b001:
    address = data1 | data2;
  3'b010:
    address = data1 + data2;
  3'b110:
    address = data1 - data2;
  3'b111: begin
    if (data1 < data2)
      address = 1;
    else if (data2 < data1)
      address = 0; 
  end
  default:
    $display("command not found");
  endcase

  zero = (address == 0) ? 1 : 0;
end
endmodule



/////////////// Register module /////////////////////
module registers(input clock, input [4:0] readRegister1, input [4:0] readRegister2, input [4:0] writeRegister, input [31:0] writeData, input regWrite, output reg [31:0] readData1, output reg [31:0] readData2, output wire [31:0] v0, output wire [31:0] a0);

reg [31:0] allRegisters [0:31];
integer j;

initial begin
  for (j = 0; j < 32 ; j += 1)begin
    allRegisters[j] = 32'b0;
  end
end

assign v0 = allRegisters[`v0];
assign a0 = allRegisters[`a0];

always @(*) begin
  readData1 = allRegisters[readRegister1];
  readData2 = allRegisters[readRegister2];
end

always @(negedge clock)begin
  if (regWrite == 1) begin
    allRegisters[writeRegister] = writeData;
  end
end 

endmodule



///////////////// Sign Extend //////////////
module signExtend(input [15:0] immediate, output [31:0] extendImmediate);
  assign extendImmediate = {{16{immediate[15]}}, immediate};
endmodule

/////////////////// Syscalls ///////////////
module callSyscall(input syscall, input [31:0] v, input [31:0] a);
always @(*) begin
  if(syscall == 1) begin
    if(v == 1) begin
      $display("This prints: %d", a);
    end

    else if(v == 10) begin
      $finish;
    end
  end
end
endmodule
//////////// TestBench /////////////
module testbench;
wire [31:0] nextPC;
wire [31:0] currPC;
wire [31:0] inst;
wire [31:0] PCplus4;
wire [31:0] jumpAddr;


wire [10:0] controlSignal;
wire [31:0] writeData;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] signExtend;

wire [31:0] aluOut;
wire [31:0] aluMuxOut;

wire [31:0] registerv0;
wire [31:0] registera0;

wire [4:0] writeRegister;

wire Zero;
wire syscallControl;
reg clock = 1;

pc testPC(clock, nextPC, currPC); //done
add4 adder(currPC, PCplus4);
memory mem(currPC, inst);
calculateJumpAddress jumper(inst, PCplus4, jumpAddr);
//assign jumpAddr = {PCplus4[31:28], inst[25:0] << 2};

control ctrl(inst, syscallControl, controlSignal);
registers register(clock, inst[25:21], inst[20:16], writeRegister, writeData, controlSignal[4], readData1, readData2, registerv0, registera0);

registerMux muxReg(controlSignal[10], inst[20:16],inst[15:11],writeRegister); //done

callSyscall Syscall(syscallControl, registerv0, registera0); //done

mux2to1Bit muxJump(1'b0,PCplus4, jumpAddr, nextPC); //done
signExtend signExtended(inst[15:0],signExtend); //done
mux2to1Bit muxALU(controlSignal[1], readData2, signExtend, aluMuxOut); //done
alu ALU(readData1, aluMuxOut, controlSignal[5:3], writeData, Zero);
always begin
	#1 clock = ~clock;
end 

initial begin
  $dumpfile("testbench.vcd");
  $dumpvars(0,testbench);

  //$monitor($time, "in %m, currPC %08x, nextPC = %08x, inst =%08x, jumpAddr =%08x, PCplus4 =%08x, jumpOut=%01x", currPC, nextPC, inst, jumpAddr, PCplus4, jumpOut);
  #100 
	$finish;
end
endmodule

