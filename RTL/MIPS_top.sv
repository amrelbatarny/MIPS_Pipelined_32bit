module MIPS_top #(
    parameter WORD_WIDTH = 32,
    parameter DEPTH = 1024,
    parameter MEM_ADDR_SIZE = 32,
	parameter REG_DEPTH = 32,
	parameter REG_ADDR_SIZE = 5
	)(
	//Global inputs
	input clk, reset_n,

	//Register File ports
	output logic MEM_WB_RegWrite,
	output logic [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt, MEM_WB_RegisterRd,
	output logic [WORD_WIDTH-1:0] RegWriteData, RegReadData1, RegReadData2,

	//Data Memory ports
    output logic EX_MEM_MemRead, EX_MEM_MemWrite,
    output logic [WORD_WIDTH-1:0] EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData,

    //Instruction Memory ports
    output logic [WORD_WIDTH-1:0] PC_out, instruction,
    output logic IF_Flush, IF_IDWrite,

    //Exception PC (EPC) register
    output logic [WORD_WIDTH-1:0] EPC
	);

	logic [5:0] opcode;
	logic overflow, PCSrc;
	logic RegDst, Branch_eq, Branch_ne, MemtoReg, EX_Flush, ID_Flush;
	logic MemRead, MemWrite, ALUSrc, RegWrite;
	logic [1:0] ALUOp;
	logic exception;
	logic EX_MEM_RegWrite;
	logic [4:0] EX_MEM_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt;
	logic [1:0] ForwardA, ForwardB;
	logic ID_EX_MemRead;
	logic PCWrite, Stall;

	MIPS_datapath Datapath(
		clk, reset_n,
		opcode,
		overflow, PCSrc,
		RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush,
		MemRead, MemWrite, ALUSrc, RegWrite,
		ALUOp,
		exception,
		EX_MEM_RegWrite, MEM_WB_RegWrite,
		EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt,
		ForwardA, ForwardB,
		ID_EX_MemRead,
		IF_ID_RegisterRs, IF_ID_RegisterRt,
		PCWrite, IF_IDWrite, Stall,
		RegWriteData, RegReadData1, RegReadData2,
		EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData, PC_out, instruction, EPC);

	MIPS_control Control(
		opcode,
		overflow, PCSrc,
		RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush,
		MemRead, MemWrite, ALUSrc, RegWrite,
		ALUOp,
		exception,
		EX_MEM_RegWrite, MEM_WB_RegWrite,
		EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt,
		ForwardA, ForwardB,
		ID_EX_MemRead,
		IF_ID_RegisterRs, IF_ID_RegisterRt,
		PCWrite, IF_IDWrite, Stall);

endmodule : MIPS_top