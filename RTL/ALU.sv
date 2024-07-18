module ALU #(
    parameter WIDTH = 32
)(
    input [3:0] ALU_control,
    input [4:0] shamt,
    input signed [WIDTH-1:0] A, B,
    output logic signed [WIDTH-1:0] ALU_result,
    output logic Zero, overflow
);

    assign Zero = (ALU_result == 0)? 1'b1 : 1'b0;
    
    always_comb begin
        case(ALU_control)
            4'b0000: //AND
            begin
                ALU_result = A & B;
                overflow = 0;        
            end

            4'b0001: //OR
            begin
                ALU_result = A | B;
                overflow = 0;        
            end

            4'b0010: //ADD
            begin
                ALU_result = A + B;
                if ((A[WIDTH-1] == B[WIDTH-1]) && (ALU_result[WIDTH-1] != A[WIDTH-1]))
                    overflow = 1;
                else
                    overflow = 0;
            end
            
            4'b0110: //SUB
            begin
                ALU_result = A - B;
                if ((A[WIDTH-1] != B[WIDTH-1]) && (ALU_result[WIDTH-1] != A[WIDTH-1]))
                    overflow = 1;
                else
                    overflow = 0;
            end
            
            4'b0111: //SLT
            begin
                if(A < B)
                    ALU_result = 1;
                else
                    ALU_result = 0;
                overflow = 0;
            end
    
            4'b1100: //NOR
            begin
               ALU_result = ~(A | B);
               overflow = 0; 
            end

            4'b1111: //SLL
            begin
                ALU_result = B << shamt;
                overflow = 0;
            end
            
            default:
            begin
                ALU_result = A & B;
                overflow = 0;        
            end
        endcase
    end

endmodule