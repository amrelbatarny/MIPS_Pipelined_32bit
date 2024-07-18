module MIPS_control (
	input [5:0] opcode,
	input overflow, PCSrc,
	output RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush,
	output MemRead, MemWrite, ALUSrc, RegWrite,
	output [1:0] ALUOp,
	output exception,

	input EX_MEM_RegWrite, MEM_WB_RegWrite,
	input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt,
	output [1:0] ForwardA, ForwardB,

	input ID_EX_MemRead,
	input [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt,
	output PCWrite, IF_IDWrite, Stall
);
	
	Main_control Main_Control_unit(opcode, overflow, PCSrc, RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush, MemRead, MemWrite, ALUSrc, RegWrite, ALUOp, exception);
	Forwarding Forwarding_unit(EX_MEM_RegWrite, MEM_WB_RegWrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt, ForwardA, ForwardB);
	Hazard_detection Hazard_detection_unit(ID_EX_MemRead, ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt, PCWrite, IF_IDWrite, Stall);
										   
endmodule : MIPS_control