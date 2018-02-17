// Evan Harrington
// CSCI320
// Project 1 
`include "mips.h"
//////////////////// Control Module ///////////////////
module control(input [31:0] inst, output reg syscallControl, output reg jrControl, output reg jalControl, output reg [10:0] controlSig);
  reg RegDst;
  reg Jump;
  reg Branch;
  reg MemRead;
  reg MemToReg;
  reg [2:0] ALUOp;
  reg RegWrite;
  reg ALUsrc;
  reg MemWrite;

  always @(inst)begin
    RegDst = 0;
    Jump = 0;
    Branch = 0;
    MemRead = 0;
    MemToReg = 0;
    ALUOp = 3'b000;
    RegWrite = 0;
    ALUsrc = 0;
    MemWrite = 0;
    syscallControl = 0;
    jrControl = 0;
    jalControl = 0;

    //$display("I'm trying to learn what op is %6b and the function code %6b", inst[`op], inst[`function]);
    case (inst[`op])
      `J:
        begin
        $display("Jump");
          Jump = 1;
        end
      `JAL:
        begin
        $display("Jump and link");
          Jump = 1; RegWrite = 1; jalControl = 1;
        end

      `ADDI , `ADDIU:
        begin
        $display("Addi and Addiu");
          RegWrite = 1; ALUOp = 3'b010; ALUsrc = 1;
        end

      `ORI:
        begin
        $display("ORI");
          RegWrite = 1; ALUOp = 3'b001; ALUsrc = 1;
        end

      `BEQ , `BNE:
        begin
        $display("BEQ and BNE");
          Branch = 1; ALUOp = 3'b110;
        end

      `LUI:
        begin
        $display("LUI");
          RegWrite = 1; ALUsrc = 1; ALUOp = 3'b011;
        end

      `LW:
        begin
        $display("LW");
          MemRead = 1; MemToReg = 1; RegWrite = 1; ALUsrc = 1; ALUOp = 3'b010;
        end

      `SW:
        begin
        $display("SW");
          ALUOp = 3'b010; ALUsrc = 1; MemWrite = 1;
        end

      `SPECIAL:
        begin
          RegDst=1; RegWrite = 1;

          case (inst[`function])
            `ADD:begin
              $display("ADD");
              ALUOp = 3'b010;
            end
            `SUB: begin
              $display("SUB");
              ALUOp = 3'b110;
            end
            `AND: begin
              $display("ANd");
              ALUOp = 3'b000;
            end
            `OR: begin
              $display("OR");
              ALUOp = 3'b001;
            end
            `SLT: begin
              $display("SLT");
              ALUOp = 3'b111;
            end
            `JR: begin
              $display("We at JR");
              Jump = 1; RegWrite = 1; jrControl = 1;
            end
            `SYSCALL:
            begin
              $display("Syscall");
              syscallControl = 1; RegWrite = 1;
            end

            6'b000000: 
            begin
              ALUOp = 3'bxxx;
              $display("This is a NOP");
            end

            default:
              $display("R Instruction can't be found\n");
            endcase
        end       
        default:
          $display("Instruction Not Found\n");

    endcase

    controlSig = {RegDst, Jump, Branch, MemRead, MemToReg, ALUOp, RegWrite, ALUsrc, MemWrite};
    // $display("syscall control = %d", syscall_control);
    // $display("ALUop = %03x\nRegDst = %01x | Jump = %01x | Branch = %01x | MemRead = %01x | MemToReg = %01x | RegWrite = %01x | ALUsrc = %01x | MemWrite = %01x\n", ALUop, RegDst, Jump, Branch, MemRead, MemToReg, RegWrite, ALUsrc, MemWrite);
    // $display("");
  end
endmodule
