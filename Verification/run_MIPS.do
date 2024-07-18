vlib work
vlog -f src_files.list -mfcu 
vsim -voptargs=+acc work.MIPS_tb
#add wave *
add wave	-radix hexadecimal	-color gold		sim:/MIPS_tb/clk
add wave	-radix hexadecimal	-color gold		sim:/MIPS_tb/reset_n
add wave	-radix hexadecimal	-color gold		sim:/MIPS_tb/instruction
add wave	-radix hexadecimal	-color gold		sim:/MIPS_tb/DUT/Datapath/IF_ID_Opcode
add wave	-radix hexadecimal 	-color magenta	sim:/MIPS_tb/DUT/Datapath/InstructionMemory_inst/Instructions
add wave	-radix hexadecimal	-color magenta	sim:/MIPS_tb/DUT/Datapath/DataMemory_inst/Data
add wave	-radix hexadecimal	-color magenta	sim:/MIPS_tb/DUT/Datapath/RegisterFile_inst/Registers
add wave	-radix hexadecimal					sim:/MIPS_tb/IF_ID_RegisterRs
add wave	-radix hexadecimal					sim:/MIPS_tb/IF_ID_RegisterRt
add wave	-radix hexadecimal					sim:/MIPS_tb/MEM_WB_RegisterRd
add wave	-radix hexadecimal					sim:/MIPS_tb/RegWriteData
add wave	-radix hexadecimal					sim:/MIPS_tb/RegReadData1
add wave	-radix hexadecimal					sim:/MIPS_tb/RegReadData2
add wave	-radix hexadecimal					sim:/MIPS_tb/EX_MEM_ALU_result
add wave	-radix hexadecimal					sim:/MIPS_tb/EX_MEM_MemWriteData
add wave	-radix hexadecimal					sim:/MIPS_tb/MemReadData
add wave	-radix hexadecimal					sim:/MIPS_tb/PC_out
add wave	-radix hexadecimal					sim:/MIPS_tb/EPC
add wave	-radix hexadecimal					sim:/MIPS_tb/DUT/Datapath/EX_MEM_RegisterRd
add wave	-radix hexadecimal					sim:/MIPS_tb/DUT/Datapath/ID_EX_RegisterRs
add wave	-radix hexadecimal					sim:/MIPS_tb/DUT/Datapath/ID_EX_RegisterRt

add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/exception
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/IF_Flush
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/IF_IDWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/PCSrc
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/RegDst
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/Branch_eq
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/Branch_ne
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/MemtoReg
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/EX_Flush
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ID_Flush
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ALUSrc
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/RegWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/MEM_WB_RegWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ALUOp
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/EX_MEM_RegWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ForwardA
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ForwardB
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/MemWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ID_EX_MemWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/EX_MEM_MemWrite
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/MemRead
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/ID_EX_MemRead
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/EX_MEM_MemRead
add wave	-radix hexadecimal	-color cyan		sim:/MIPS_tb/DUT/Datapath/Stall
.vcop Action toggleleafnames
run -all
#quit -sim