module Main_control (
	input [5:0] opcode,
	input overflow, PCSrc,
	output RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush,
	output reg MemRead, MemWrite, ALUSrc, RegWrite,
	output reg [1:0] ALUOp,
	output exception
);
	
	wire invalid_opcode;

	assign RegDst = ALUOp[1];
	assign Branch_eq = (opcode == 5)? 1'b0 : ALUOp[0];
	assign Branch_ne = (opcode == 5)? 1'b1 : 1'b0;
	assign IF_Flush = PCSrc;
	assign MemtoReg = (opcode == 8)? 1'b0 : ALUSrc;
	assign invalid_opcode = ((opcode != 0) && (opcode != 35) && (opcode != 43) && (opcode != 4) && (opcode != 5) && (opcode != 8))? 1'b1 : 1'b0;
	assign EX_Flush = overflow;
	assign ID_Flush = (invalid_opcode)? 1'b1 : 1'b0;
	assign exception = (invalid_opcode || overflow)? 1'b1 : 1'b0;

	always_comb begin
		case(opcode)
			0: //R-format
			begin
				ALUOp = 2;
				ALUSrc = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 1;
			end
			35: //lw
			begin
				ALUOp = 0;
				ALUSrc = 1;
				MemRead = 1;
				MemWrite = 0;
				RegWrite = 1;
			end
			43: //sw
			begin
				ALUOp = 0;
				ALUSrc = 1;
				MemRead = 0;
				MemWrite = 1;
				RegWrite = 0;
			end
			4: //beq
			begin
				ALUOp = 1;
				ALUSrc = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 0;
			end
			5: //bne
			begin
				ALUOp = 1;
				ALUSrc = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 0;
			end
			8: //addi
			begin
				ALUOp = 0;
				ALUSrc = 1;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 1;
			end
			default:
			begin
				ALUOp = 2;
				ALUSrc = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 1;
			end
		endcase
	end

endmodule : Main_control