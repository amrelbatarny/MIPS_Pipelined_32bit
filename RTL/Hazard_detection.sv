module Hazard_detection (
	input ID_EX_MemRead,
	input [4:0] ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt,
	output reg PCWrite, IF_IDWrite, Stall
);
	
	always_comb begin
		if (ID_EX_MemRead &&
		((ID_EX_RegisterRt == IF_ID_RegisterRs) ||
		(ID_EX_RegisterRt == IF_ID_RegisterRt))) begin
			PCWrite = 0;
			IF_IDWrite = 0;
			Stall = 1;
		end else begin
			PCWrite = 1;
			IF_IDWrite = 1;
			Stall = 0;
		end
	end
		
endmodule : Hazard_detection