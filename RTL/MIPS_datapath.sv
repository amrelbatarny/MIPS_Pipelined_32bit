module MIPS_datapath #(
    parameter MEM_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter DEPTH = 1024,
    parameter MEM_ADDR_SIZE = 32,
	parameter REG_DEPTH = 32,
	parameter REG_ADDR_SIZE = 5
	)(
	//Control unit ports
	input clk, reset_n,
	output logic [5:0] IF_ID_Opcode,
	output logic overflow, PCSrc,
	input RegDst, Branch_eq, Branch_ne, IF_Flush, MemtoReg, EX_Flush, ID_Flush,
	input MemRead, MemWrite, ALUSrc, RegWrite,
	input [1:0] ALUOp,
	input exception,

	output logic EX_MEM_RegWrite, MEM_WB_RegWrite,
	output logic [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt,
	input [1:0] ForwardA, ForwardB,

	output logic ID_EX_MemRead,
	output logic [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt,
	input PCWrite, IF_IDWrite, Stall,

	//Register File ports
	output logic [WORD_WIDTH-1:0] RegWriteData, RegReadData1, RegReadData2,

    //Data Memory ports
    output logic EX_MEM_MemRead, EX_MEM_MemWrite,
    output logic [WORD_WIDTH-1:0] EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData,

    //Instruction Memory ports
    output logic [WORD_WIDTH-1:0] PC_out, instruction,

    //Exception PC (EPC) register
    output logic [WORD_WIDTH-1:0] EPC
	);

	
	//////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////Stage(1) Instruction Fetch//////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	logic equality;
	logic [WORD_WIDTH-1:0] PC_in, IF_ID_next_Instruction, branch_target, next_Instruction;

	assign PCSrc = ((Branch_eq & equality) || (Branch_ne & !equality))? 1'b1 : 1'b0;
	assign next_Instruction = PC_out + 4;

	PC #(WORD_WIDTH) PC_inst(clk, reset_n, PCWrite, PC_in, PC_out);
	InstructionMemory #(MEM_WIDTH, WORD_WIDTH, DEPTH, MEM_ADDR_SIZE) InstructionMemory_inst(clk, IF_Flush, IF_IDWrite, PC_out, instruction);

	always_comb begin : PC_mux
		if(exception)
			PC_in = 32'h80000180;
		else if(PCSrc)
			PC_in = branch_target;
		else
			PC_in = next_Instruction;
	end

	always @(posedge clk) begin : IF_ID_pipeline_register
		if(IF_IDWrite)
			IF_ID_next_Instruction <= next_Instruction;
	end

	///////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////Stage(2) Instruction Decode//////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////
	logic ID_EX_RegDst, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite;
	logic [1:0] ID_EX_ALUOp;
	logic [4:0] IF_ID_RegisterRd, ID_EX_RegisterRd, IF_ID_Shamt, ID_EX_Shamt;
	logic [5:0] ID_EX_Funct, IF_ID_Funct;
	logic [15:0] IF_ID_Immediate;
	logic [WORD_WIDTH-1:0] IF_ID_SignedImmediate, ID_EX_RegReadData1, ID_EX_RegReadData2, ID_EX_SignedImmediate, IF_ID_ShiftedImmediate, ID_EX_next_Instruction, ID_EX_ReadData1, ID_EX_ReadData2;

	assign IF_ID_Opcode = instruction[31:26];
	assign IF_ID_RegisterRs = instruction[25:21];
	assign IF_ID_RegisterRt = instruction[20:16];
	assign IF_ID_RegisterRd = instruction[15:11];
	assign IF_ID_Shamt = instruction[10:6];
	assign IF_ID_Funct = instruction[5:0];
	assign IF_ID_Immediate = instruction[15:0];
	assign IF_ID_SignedImmediate = {{16{IF_ID_Immediate[15]}}, IF_ID_Immediate};
	assign IF_ID_ShiftedImmediate = {IF_ID_SignedImmediate[WORD_WIDTH-3:0], {2{1'b0}}};
	assign equality = (RegReadData1 == RegReadData2)? 1'b1 : 1'b0;
	assign branch_target = IF_ID_ShiftedImmediate + IF_ID_next_Instruction;

	RegisterFile #(WORD_WIDTH, REG_DEPTH, REG_ADDR_SIZE) RegisterFile_inst(clk, MEM_WB_RegWrite, IF_ID_RegisterRs, IF_ID_RegisterRt, MEM_WB_RegisterRd, RegWriteData, RegReadData1, RegReadData2);

	always @(posedge clk) begin : ID_EX_pipeline_register
		if(ID_Flush | Stall) begin
			ID_EX_RegDst <= 0;
			ID_EX_MemtoReg <= 0;
			ID_EX_MemRead <= 0;
			ID_EX_MemWrite <= 0;
			ID_EX_ALUSrc <= 0;
			ID_EX_RegWrite <= 0;
			ID_EX_ALUOp <= 0;
		end else begin
			ID_EX_RegDst <= RegDst;
			ID_EX_MemtoReg <= MemtoReg;
			ID_EX_MemRead <= MemRead;
			ID_EX_MemWrite <= MemWrite;
			ID_EX_ALUSrc <= ALUSrc;
			ID_EX_RegWrite <= RegWrite;
			ID_EX_ALUOp <= ALUOp;
			ID_EX_next_Instruction <= IF_ID_next_Instruction;
			ID_EX_RegisterRs <= IF_ID_RegisterRs;
			ID_EX_RegisterRt <= IF_ID_RegisterRt;
			ID_EX_RegisterRd <= IF_ID_RegisterRd;
			ID_EX_Funct <= IF_ID_Funct;
			ID_EX_SignedImmediate <= IF_ID_SignedImmediate;
			ID_EX_RegReadData1 <= RegReadData1;
			ID_EX_RegReadData2 <= RegReadData2;
			ID_EX_Shamt <= IF_ID_Shamt;
			EPC <= ID_EX_next_Instruction;
		end
	end

	//////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////Stage(3) Execution//////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	logic Zero, EX_MEM_MemtoReg;
	logic [3:0] ALU_control;
	logic [4:0] RegisterRd;
	logic [WORD_WIDTH-1:0] A, B, B_ReadData, ALU_result;

	assign A = (ForwardA == 2'b00) ? ID_EX_RegReadData1 :
               (ForwardA == 2'b01) ? RegWriteData :
               EX_MEM_ALU_result;
    assign B_ReadData = (ForwardB == 2'b00) ? ID_EX_RegReadData2 :
               			(ForwardB == 2'b01) ? RegWriteData :
               			EX_MEM_ALU_result;
    assign B = (ID_EX_ALUSrc == 1'b1)? ID_EX_SignedImmediate : B_ReadData;
    assign RegisterRd = (ID_EX_RegDst == 1'b1)? ID_EX_RegisterRd : ID_EX_RegisterRt;

	ALU #(WORD_WIDTH) ALU_inst(ALU_control, ID_EX_Shamt, A, B, ALU_result, Zero, overflow);
	ALUControl ALUControl_inst(ID_EX_ALUOp, ID_EX_Funct, ALU_control);

	always @(posedge clk) begin : EX_MEM_pipeline_register
		if(EX_Flush) begin
			EX_MEM_MemtoReg <= 0;
			EX_MEM_MemRead <= 0;
			EX_MEM_MemWrite <= 0;
			EX_MEM_RegWrite <= 0;
		end else begin
			EX_MEM_MemtoReg <= ID_EX_MemtoReg;
			EX_MEM_MemRead <= ID_EX_MemRead;
			EX_MEM_MemWrite <= ID_EX_MemWrite;
			EX_MEM_RegWrite <= ID_EX_RegWrite;
			EX_MEM_ALU_result <= ALU_result;
			EX_MEM_MemWriteData <= B_ReadData;
			EX_MEM_RegisterRd <= RegisterRd;
		end
	end

	//////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////Stage(4) Memory access////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	logic MEM_WB_MemtoReg;
	logic [WORD_WIDTH-1:0] MEM_WB_ALU_result;

	DataMemory #(MEM_WIDTH, WORD_WIDTH, DEPTH, MEM_ADDR_SIZE) DataMemory_inst(clk, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData);
	
	always @(posedge clk) begin : MEM_WB_pipeline_register
		MEM_WB_ALU_result <= EX_MEM_ALU_result;
		MEM_WB_RegWrite <= EX_MEM_RegWrite;
		MEM_WB_RegisterRd <= EX_MEM_RegisterRd;
		MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
	end

	///////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////Stage(5) Write back//////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////
	assign RegWriteData = (MEM_WB_MemtoReg == 1'b1)? MemReadData : MEM_WB_ALU_result;



endmodule : MIPS_datapath