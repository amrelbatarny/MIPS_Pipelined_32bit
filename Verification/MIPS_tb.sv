module MIPS_tb ();
	parameter WORD_WIDTH = 32;
    parameter DEPTH = 1024;
    parameter MEM_ADDR_SIZE = 32;
	parameter REG_DEPTH = 32;
	parameter REG_ADDR_SIZE = 5;

	//Global inputs
	logic clk, reset_n;

	//Register File ports
	logic MEM_WB_RegWrite;
	logic [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt, MEM_WB_RegisterRd;
	logic [WORD_WIDTH-1:0] RegWriteData, RegReadData1, RegReadData2;

	//Data Memory ports
    logic EX_MEM_MemRead, EX_MEM_MemWrite;
    logic [WORD_WIDTH-1:0] EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData;

    //Instruction Memory ports
    logic [WORD_WIDTH-1:0] PC_out, instruction;
    logic IF_Flush, IF_IDWrite;

    //Exception PC (EPC) register
    logic [WORD_WIDTH-1:0] EPC;

	MIPS_top DUT(clk, reset_n, MEM_WB_RegWrite, IF_ID_RegisterRs, IF_ID_RegisterRt, MEM_WB_RegisterRd, RegWriteData, RegReadData1,
		RegReadData2, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_ALU_result, EX_MEM_MemWriteData, MemReadData, PC_out, instruction,
   		IF_Flush, IF_IDWrite, EPC);

	initial begin
		clk = 0;
		forever
			#1 clk = ~clk;
	end

	initial begin
		$readmemh("../Memory_Initialization/InstructionMemory.dat", DUT.Datapath.InstructionMemory_inst.Instructions);
		$readmemh("../Memory_Initialization/DataMemory.dat", DUT.Datapath.DataMemory_inst.Data);
		$readmemh("../Memory_Initialization/RegisterFile.dat", DUT.Datapath.RegisterFile_inst.Registers);

		reset_n = 0;
		@(negedge clk) reset_n = 1;

		repeat(75) @(negedge clk);
		$stop;
	end

endmodule : MIPS_tb