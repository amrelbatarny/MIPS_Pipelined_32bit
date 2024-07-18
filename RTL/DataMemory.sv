module DataMemory #(
    parameter MEM_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter MEM_DEPTH = 1024,
    parameter ADDR_SIZE = 32
) (
    input clk, MemRead, MemWrite,
    input [ADDR_SIZE-1:0] address,
    input [WORD_WIDTH-1:0] write_data,
    output reg [WORD_WIDTH-1:0] read_data
);

    reg [MEM_WIDTH-1:0] Data [0:MEM_DEPTH-1];

    always @(posedge clk) begin
        if(MemWrite) begin
            Data[address] <= write_data[31:24];
            Data[address+1] <= write_data[23:16];
            Data[address+2] <= write_data[15:8];
            Data[address+3] <= write_data[7:0];
        end
        if(MemRead)
            read_data <= {Data[address], Data[address+1], Data[address+2], Data[address+3]};
    end
    
endmodule


/*module DataMemory #(
    parameter MEM_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter MEM_DEPTH = 1024,
    parameter ADDR_SIZE = 32
) (
    input clk, MemRead, MemWrite,
    input [ADDR_SIZE-1:0] address,
    input [WORD_WIDTH-1:0] write_data,
    output reg [WORD_WIDTH-1:0] read_data
);

    reg [MEM_WIDTH-1:0] Data [0:MEM_DEPTH-1];

    logic [7:0] r_byte0, r_byte1, r_byte2, r_byte3, w_byte0, w_byte1, w_byte2, w_byte3;
    logic [MEM_WIDTH-1:0] addr0, addr1, addr2, addr3;

    assign addr0 = address + 3;
    assign addr1 = address + 2;
    assign addr2 = address + 1;
    assign addr3 = address;

    assign read_data = {r_byte3, r_byte2, r_byte1, r_byte0};
    assign {w_byte3, w_byte2, w_byte1, w_byte0} = write_data;

    always @(posedge clk) begin
        if(MemWrite)
            Data[addr3] <= w_byte3;
            Data[addr2] <= w_byte2;
            Data[addr1] <= w_byte1;
            Data[addr0] <= w_byte0;
        if(MemRead)
            r_byte3 <= Data[addr3];
            r_byte2 <= Data[addr2];
            r_byte1 <= Data[addr1];
            r_byte0 <= Data[addr0];
    end

endmodule
*/