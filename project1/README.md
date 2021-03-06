Evan Harrington
CSCI320
Project1: Single Cycle MIPS Processor
Due: February 16, 2018
    
    My Single Cycle MIPS Processor is comprised of 15 modules spanning over different files. I modeled my processor after the picture of the MIPS Processor in the project1 folder. This gave us a better understanding of how to connect inputs and outputs. To begin with, we import the 'mips.h' files, which defines alld the different gglobal constants for op codes, function codes, control signals, and registers. This is mostly used in the control module and the Mips.v testbench module which I will talk about later.
    We begin our trace of the processor path at the PC counter, which will figure out where to read incoming instructions. This instruction memory block then reads the instruction and will output the different parts of the instruction to different blocks of the processor. Instructions can be broken down into a few different pieces, including: op code (inst[31:26]), register specifier (inst[25:21]), 16-bit Immediate(inst[15:0]), and others. Each of these different parts of the instruction will be passed to different blocks within the processor to be executed. For example, the opcode gets passed to the control block, which creates bit signals that will be inputs or control other blocks within the processor. The next block is the register block which takes in the data from registers and outputs it to the ALU. With the previous control outputs, the ALU will do an operation and then will pass the ALUresult to the data memory block. This block is where the processor can read data, write data, and pass data memory back to registers to be (potentially) written.
    While this is going on, the program counter will take current pc instruction and add 4 to make the next pc instruction (this will be different for J and Branch instructions). Mux modules will take inputs of control signals and will choose one of two signals to pass on as na output. These mux modules come into play when choosing locations for writeData, registers, and next pc. This is a brief overlook of the single cycle mips processor.

Testing and Running Code:
To run the code, one should enter into the project1 directory and then terminal command: iverilog -o mips Mips.v.

In order to test the other programs do the following:
To run add_test, change the $readmemh statement in `memory.v` to include the `add_test.v`. Then you can compile the code with this terminal code: `iverilog -o addTest Mips.v`

To fibonacci5, change the $readmemh statement in `memory.v` to include the `fibonacci5.v`. Then you can compile the code with this terminal code: `iverilog -o fibo5Out Mips.v`

To fibonacci10, change the $readmemh statement in `memory.v` to include the `fibonacci10.v`. Then you can compile the code with this terminal code: `iverilog -o fibo10Out Mips.v`

Execute the code using the following terminal commands:
add_test:  		`vvp addTest`
fibonacci5:  	`vvp fib5Out`
fibonacci10:  	`vvp fib10Out`




