module PC #(parameter WIDTH = 32)(
	input clk, reset_n, PCWrite,
	input [WIDTH-1:0] PC_load,
	output reg [WIDTH-1:0] PC_next
	);

	always @(posedge clk) begin
		if(~reset_n)
			PC_next <= 0;
		else if(PCWrite)
			PC_next <= PC_load;
	end

endmodule : PC