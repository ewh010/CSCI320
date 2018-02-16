// Evan Harrington
// CSCI320
// Project 1 

`include "mips.h"
`include "pc.v"
`include "add4.v"
`include "adder.v"
`include "memory.v"
`include "JumpAdder.v"
`include "control.v"
`include "mux2to1.v"
`include "alu.v"
`include "register.v"
`include "syscall.v"
`include "signExtend16to32.v"
`include "mux5bit.v"
`include "and.v"
`include "dataMem.v"

///////////// Testbench Module /////////////////
module testbench;    
    wire [31:0] nextPC;
    wire [31:0] currPC;
    wire [31:0] inst;
    wire [31:0] pcPlus4;
    wire [31:0] jumpAddr;

    wire [10:0] controlSig;
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] signExtendedValue;
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
    // gets the current PC 
    pc pcBlock(clock, nextPC, currPC);
    // adds 4 to current pc to make next pc
    add4 add4PC(currPC, pcPlus4);
    // fetches instruction from mem
    memory instructionMemory(currPC, inst);
    // creates new jump address
    JumpAdder jumpAddressBlock(inst, pcPlus4, jumpAddr);
    // takes in all the control signals
    control controlBlock(inst, syscallControl, jrControl, jalControl, controlSig);
    // 2 to 1 bit mux for reg write
    mux5bit registerMux(controlSig[`REGDST], inst[20:16], inst[15:11], writeReg);
    // all registers execution block
    register registerBlock(clock, jalControl, currPC + 8, inst[25:21], inst[20:16],writeReg, writeData, controlSig[`REGWRITE], readData1, readData2, v0, a0, ra);
    // sign extend immediate
    signExtend16to32 signExtendBlock(inst,signExtendedValue);
    // adder for the branch address
    adder branchAddressAdder(pcPlus4, signExtendedValue,branchAdderOut);
    // ALU Mux
    mux2to1 muxALU(controlSig[`ALUSRC], readData2, signExtendedValue, aluMuxOut);
    // execution for the ALU block
    alu ALUBlock(readData1, aluMuxOut, controlSig[`ALUOP], aluResult, Zero);
    // Logical And Gate used in MUX
    and andOPGate(controlSig[`BRANCH], Zero, andOut);
    //mux for Branch Bontrol block
    mux2to1 muxBranch(andOut, pcPlus4,branchAdderOut,branch_mux_out);
    //mux for Jump Control 
    mux2to1 muxJump(controlSig[`JUMP], branch_mux_out, jrMux_out, nextPC);
        // execute data memory for read/write
    dataMem dataMemory(clock, controlSig[`MEMWRITE], controlSig[`MEMREAD], aluResult, readData2, readData_mem);

    // mux to control input to writeData
    mux2to1 memToRegMux(controlSig[`MEMTOREG], aluResult, readData_mem, writeData);

    // mux for jr control
    mux2to1 jrMux(jrControl, jumpAddr, ra, jrMux_out);



    always begin
        #10 clock = ~clock;
    end

    initial begin
        clock = 1;
        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);
        // $monitor($time, " in %m, currPC = %08x, nextPC = %08x, instruction = %08x\n", currPC, nextPC, instr);
        #50000 $finish;
    end
endmodule






