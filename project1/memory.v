// Evan Harrington
// CSCI320
// Project 1 

/////////// memory module /////////////
module memory(input [31:0] currPC, output reg [31:0] inst);

    reg [31:0] mem[29'h00100000:29'h00100100];

    initial begin
        $readmemh("./Fibo/fibonacciNew.v", mem);
        // $readmemh("add_test.v", mem);
    end

    always @(currPC) begin
        inst = mem[currPC[31:2]];
    end
endmodule
