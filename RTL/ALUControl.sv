module ALUControl (
	input [1:0] ALUOp,
	input [5:0] funct,
	output reg [3:0] ALU_control
);

	always_comb begin
		if(ALUOp == 2'b00)
			ALU_control = 4'b0010; 				//Instruction operation: lw/sw,	Desired ALU action: ADD
		else if(ALUOp == 2'b01)
			ALU_control = 4'b0110;
		else begin
			case(funct)
				6'b100000: 	ALU_control = 4'b0010; //Instruction operation: add, 	Desired ALU action: ADD
				6'b100010: 	ALU_control = 4'b0110; //Instruction operation: sub, 	Desired ALU action: SUB
				6'b100100: 	ALU_control = 4'b0000; //Instruction operation: and, 	Desired ALU action: AND
				6'b100101: 	ALU_control = 4'b0001; //Instruction operation: or, 	Desired ALU action: OR
				6'b101010: 	ALU_control = 4'b0111; //Instruction operation: slt,	Desired ALU action: SLT
				6'b000000: 	ALU_control = 4'b1111; //Instruction operation: sll,	Desired ALU action: SLL
				default: 	ALU_control = 4'b0010; //Instruction operation: add, 	Desired ALU action: ADD
			endcase
		end
	end

endmodule : ALUControl