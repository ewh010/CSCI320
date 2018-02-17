// Evan Harrington
// CSCI320
// Project 1 

`include "mips.h"
`include "pc.v"
`include "adder.v"
`include "memory.v"
`include "JumpAddr.v"
`include "control.v"
`include "mux.v"
//`include "mux5bit.v"
`include "syscall.v"
`include "alu.v"
`include "register.v"
`include "signExtend16to32.v"
`include "and.v"
`include "dataMem.v"


///////////// Testbench Module /////////////////
module testbench;
    wire [31:0] nextPC;
    wire [31:0] currPC;
    wire [31:0] inst;
    wire [31:0] PCplus4;
    wire [31:0] jumpAddr;

    wire [10:0] controlOut;
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] signExtendValue;
    wire [31:0] aluResult;
    wire [31:0] aluMuxOut;

    wire [31:0] v0;
    wire [31:0] a0;
    wire [31:0] ra;
    wire [31:0] readData_mem;
    wire [31:0] branchAdderOut;
    wire [31:0] branch_mux_out;
    wire [31:0] jrMux_out;
    wire [4:0] writeReg;

    wire syscallControl;
    wire jalControl;
    wire jrControl;

    wire Zero;
    wire andOut;
    reg clock;

    // get current pc
    pc PCBlock(clock, nextPC, currPC);
    // adds 4 to current pc to make next pc
    add4 add4PC(currPC, PCplus4);
    // fetches instruction from mem
    memory memoryInst(currPC, inst);
    // creates new jump address
    JumpAddr JumpAddrBlock(inst, PCplus4, jumpAddr);
    // takes in all the control signals
    control controlBlock(inst, syscallControl, jrControl, jalControl, controlOut);
    
    // all registers execution block
    register regBlock(clock, jalControl, currPC+8, inst[25:21], inst[20:16], writeReg, writeData, controlOut[`REGWRITE], readData1, readData2, v0, a0, ra);
    // 2 to 1 bit mux for reg write
    mux5bit registerMux(controlOut[`REGDST], inst[20:16], inst[15:11], writeReg);

    // syscall execute when needed
    syscall testSyscall(syscallControl, v0, a0);
    // sign extended immediate
    signExtend16to32 signExtend_block(inst, signExtendValue);

    // adder for branch address
    adder branchAdder(PCplus4, signExtendValue, branchAdderOut);
    // mux for alu
    mux2to1 aluMux(controlOut[`ALUSRC], readData2, signExtendValue, aluMuxOut);

    // execute alu block
    alu ALU_block(readData1, aluMuxOut, controlOut[`ALUOP], aluResult, Zero);

    // and gate for mux
    andOp and_gate(controlOut[`BRANCH], Zero, andOut);
    // mux for branch control
    mux2to1 branchMux(andOut, PCplus4, branchAdderOut, branch_mux_out);
    // mux for jump control
    mux2to1 jumpMux(controlOut[`JUMP], branch_mux_out, jrMux_out, nextPC);
    // data memory execute(read or write)
    dataMem dataMem(clock, controlOut[`MEMWRITE], controlOut[`MEMREAD], aluResult, readData2, readData_mem);

    // mux controls Jump Register 
    mux2to1 jrMux(jrControl, jumpAddr, ra, jrMux_out);
    // mux controls write Data
    mux2to1 memToRegMux(controlOut[`MEMTOREG], aluResult, readData_mem, writeData);



    always begin
        #10 clock = ~clock;
    end

    initial
    begin

        clock = 1;

        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);

        //$monitor($time, " in %m, currPC = %08x, nextPC = %08x, instruction = %08x\n", currPC, nextPC, instr);

        #50000 $finish;

    end

endmodule
