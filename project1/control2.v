`include "mips.h"

/* pc module
 * 
 */
module pc(input clk, input [31:0] nextPC, output reg [31:0] currPC);

initial
begin
    currPC = 32'h00400020;
end

always @(posedge clk)
begin
  if($time != 0)
    currPC <= nextPC;
end

endmodule


/* add4 module
 *
 */
module add4(input [31:0] currPC, output [31:0] PCplus4);

    assign PCplus4 = currPC + 4;

endmodule


/* memory module
 *
 */
module memory(input [31:0] currPC, output reg [31:0] instr);

    reg [31:0] mem[29'h00100000:29'h00100100];

    initial begin
        $readmemh("add_test.v", mem);
    end

    always @(currPC) begin
        instr = mem[currPC[31:2]];
    end

endmodule


/* getJumpAddr module
 *
 */
module getJumpAddr(input [31:0] instr, input [31:0] PCplus4, output wire [31:0] jumpAddr);

    assign jumpAddr = {PCplus4[31:28], instr[25:0] << 2};

endmodule


/* control module
 *
 */
module control(input [31:0] instr,  output reg syscall, output reg [10:0] signals);

  reg regDst;
  reg jump;
  reg branch;
  reg memRead;
  reg memToReg;
  reg [2:0] ALUop;
  reg regWrite;   
  reg ALUsrc;
  reg memWrite;

  always @(instr)
  begin
    regDst = 0;
    jump = 0;
    branch = 0;
    memRead = 0;
    memToReg = 0;
    ALUop = 3'b000;
    regWrite = 0;   
    ALUsrc = 0;
    memWrite = 0;
 

    case (instr[`op])
     `J, `JAL: begin
        $display("jump instruction");
        jump = 1;
      end
      `SPECIAL:
      begin
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

/* mux module for 32 bit inputs
 *
 */
module mux(input controlSignal, input [31:0] input0, input [31:0] input1, output reg [31:0] muxOut);

always @(*)
begin
  if (controlSignal == 0)
    muxOut = input0;
  else
    muxOut = input1;
end

endmodule

/* regMux module for which register is the write register
 *
 */

module regMux(input controlSignal, input [4:0] input0, input [4:0] input1, output reg [4:0] muxOut);

always @(*)
begin
  if (controlSignal == 0)
    muxOut = input0;
  else
    muxOut = input1;
end

endmodule


/* ALU module
 *
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

/* registers module
 *
 */
module registers(input clk, input [4:0] readReg1, input [4:0] readReg2, input [4:0] writeReg, input [31:0] writeData, input regWrite, output reg [31:0] readOut1, output reg [31:0] readOut2, output wire [31:0] v0, output wire [31:0] a0);

  reg [31:0] reggies[0:31];
  integer i;

  initial begin
    for(i = 0; i < 32; i += 1) begin
      reggies[i] = 32'b0;
    end
  end

  assign v0 = reggies[`v0];
  assign a0 = reggies[`a0];

  // read block
  always @(*) begin
    readOut1 = reggies[readReg1];
    readOut2 = reggies[readReg2];

  end

  // write block
  always @(negedge clk) 
  begin
    if (regWrite == 1) begin
      reggies[writeReg] = writeData;
    end
  end
endmodule

/* sign extend module
 *
 */
module signExtend(input [15:0] immediate, output [31:0] extendedImmediate);

  assign extendedImmediate = { {16{immediate[15]}}, immediate };
endmodule

/* memory read write module
 *
 */ 
module memReadWrite(input clk, input memWrite, input memRead, input [31:0] address, input [31:0] writeData, output [31:0] readData);
  
  always @(negedge clk)
  begin
    // if (memWrite == 1)
      // mem at address = writeData;
    // else if (memRead == 1)
      //readData = mem at address 

  end
endmodule

/* syscall module
 *
 */
module callSys(input syscall, input [31:0] v, input [31:0] a);

always @(*)
begin
  if(syscall == 1) begin
    if(v == 1) begin
      $display("print: %d", a);
    end
    else if(v == 10) begin
      $finish;
    end
  end
end
endmodule


/* testbench module
 *
 */
module testbench;
wire [31:0] nextPC;
wire [31:0] currPC;
wire [31:0] instr;
wire [31:0] PCplus4;
wire [31:0] jumpAddr;
wire [10:0] controlSignals;
wire [31:0] writeData;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] signExtendedValue;
wire [31:0] aluResult;
wire [31:0] aluMuxOut;
wire [31:0] regV0;
wire [31:0] regA0;
wire [4:0] writeReg;
wire syscall_control;
wire zero;
reg clk = 1;
 // get current pc
 pc PC_block(clk, nextPC, currPC);
 // add 4 to pc for next pc
 add4 PCadd4(currPC, PCplus4);
// get instruction from memory
 memory instructionMemory(currPC, instr);
 // calculate jump address
 getJumpAddr JumpAddr_block(instr, PCplus4, jumpAddr);
  // get all control signals
 control control_block(instr, syscall_control, controlSignals);
 // mux for write register
 regMux registerMux(controlSignals[10], instr[20:16], instr[15:11], writeReg);
 // execute registers block
 registers reg_block(clk, instr[25:21], instr[20:16], writeReg, writeData,controlSignals[4], readData1, readData2, regV0, regA0);
 // execute syscall if necessary
 callSys testSyscall(syscall_control, regV0, regA0);
  // mux for jump control
 mux jumpMux(1'b0, PCplus4, jumpAddr, nextPC);
 // sign extend the immediate
 signExtend signExtend_block(instr[15:0], signExtendedValue);
 // mux for alu
 mux aluMux(controlSignals[1], readData2, signExtendedValue, aluMuxOut);

 // execute alu block
alu ALU_block(readData1, aluMuxOut, controlSignals[5:3], writeData, zero);
 always begin
 #1 clk = ~clk;
 end
 initial
 begin
 $dumpfile("testbench.vcd");
 $dumpvars(0,testbench);
// $monitor($time, " in %m, currPC = %08x, nextPC = %08x, instruction = %08x\n", currPC,
// nextPC, instr);
 #100 $finish;
end
endmodule
