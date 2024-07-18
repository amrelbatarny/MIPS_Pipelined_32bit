module RegisterFile#(
    parameter REG_WIDTH = 32,
    parameter REG_DEPTH = 32,
    parameter ADDR_SIZE = 5
)(
    input clk, RegWrite,
    input [ADDR_SIZE-1:0] read_register1, read_register2, write_register,
    input [REG_WIDTH-1:0] write_data,
    output [REG_WIDTH-1:0] read_data1, read_data2
);

    reg [REG_WIDTH-1:0] Registers [0:REG_DEPTH-1];

    
    assign read_data1 = Registers[read_register1];
    assign read_data2 = Registers[read_register2];

    always @(negedge clk) begin
        if(RegWrite)
            Registers[write_register] <= write_data;
    end

endmodule