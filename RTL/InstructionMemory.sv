module InstructionMemory #(
    parameter MEM_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter MEM_DEPTH = 1024,
    parameter ADDR_SIZE = 32
) (
    input clk, IF_Flush, IF_IDWrite,
    input [ADDR_SIZE-1:0] read_address,
    output reg [WORD_WIDTH-1:0] instruction
);

    reg [MEM_WIDTH-1:0] Instructions [0:MEM_DEPTH-1];

    always @(posedge clk) begin
        if(IF_Flush)
            instruction <= 0;
        else if(IF_IDWrite)
            instruction <= {Instructions[read_address], Instructions[read_address+1], Instructions[read_address+2], Instructions[read_address+3]};
    end
    
endmodule