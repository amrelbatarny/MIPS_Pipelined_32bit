module Forwarding (
	input EX_MEM_RegWrite, MEM_WB_RegWrite,
	input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt,
	output reg [1:0] ForwardA, ForwardB
	);
	
	always_comb begin : ForwardingA
		//EX hazard(1)
		if (EX_MEM_RegWrite
		&& (EX_MEM_RegisterRd != 0)
		&& (EX_MEM_RegisterRd == ID_EX_RegisterRs))
			ForwardA = 2'b10;

		//MEM hazard(1)
		else if (MEM_WB_RegWrite
		&& (MEM_WB_RegisterRd != 0)
		// && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
		// && (EX_MEM_RegisterRd != ID_EX_RegisterRs))
		&& (MEM_WB_RegisterRd == ID_EX_RegisterRs))
			ForwardA = 2'b01;
	
		//No forwarding needed
		else begin
			ForwardA = 2'b00;
		end
	end

	always_comb begin : ForwardingB
		//EX hazard(2)
		if (EX_MEM_RegWrite
		&& (EX_MEM_RegisterRd != 0)
		&& (EX_MEM_RegisterRd == ID_EX_RegisterRt))
			ForwardB = 2'b10;

		//MEM hazard(2)
		else if (MEM_WB_RegWrite
		&& (MEM_WB_RegisterRd != 0)
		// && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
		// && (EX_MEM_RegisterRd != ID_EX_RegisterRt))
		&& (MEM_WB_RegisterRd == ID_EX_RegisterRt))
			ForwardB = 2'b01;

		//No forwarding needed
		else begin
			ForwardB = 2'b00;
		end
	end

endmodule : Forwarding

// && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
// && (EX_MEM_RegisterRd != ID_EX_RegisterRs))

// && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
// && (EX_MEM_RegisterRd != ID_EX_RegisterRt))