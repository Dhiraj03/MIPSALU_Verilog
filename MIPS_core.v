/* MIPS Core Module is the centre of all operations that handles all the operations and instantiates
   all the necessary modules
*/
`include "Control_Unit.v"
`include "Read_Registers.v"
`include "ALU32bit.v"
`include "Read_ins.v"
`include "Read_mem.v"
`include "Ins_parse.v"


module mips_core(clock);

    input clock;   // Execution happens only at positive level-transition (edge sensitive)
	
    // Program counter
    reg[31:0] PC = 32'b0;
	
    // Instruction
    wire [31:0] instruction;
	
    // Parse instruction
    wire [5:0] funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [25:0] address;
    wire [15:0] immediate;
    wire [5:0] opcode;
	
    // Signals
    wire RegRead, RegWrite, RegDst;  
    wire MemRead, MemWrite;
    wire branch_signal;
	
    // Registers contents
    wire [31:0] write_data, rs_content, rt_content, memory_read_data;
	
	
    // Instantiating all necessary modules
    read_instructions inst_mem (instruction, PC);
	
    ins_parser parse (opcode, rs, rt, rd, shamt, funct, immediate, address, instruction, PC);
	
    control_unit signals (RegRead, RegWrite,MemRead, MemWrite, RegDst, 
                                branch_signal, opcode, funct);
								 
    ALU32bit alu_process (write_data, branch_signal, opcode, rs_content, rt_content, shamt, funct, immediate);
	
    read_data_memory dataMemory (memory_read_data, write_data, rt_content, opcode, MemRead, MemWrite);
	
    read_registers contents (rs_content, rt_content, write_data, rs, rt, rd, opcode, 
                                    RegRead, RegWrite, RegDst, clock);
	
    // PC operations - The next instruction is read only when the clock is at positive edge
    always @(posedge clock) begin 
        // JUMP 
        if(opcode == 6'h2) begin
            PC = address;
        end
        // JUMP REGISTER
        else if(opcode == 6'h0 & funct == 6'h08)begin
            PC = rs_content;
        end
        // BRANCH
        else if(write_data == 0 & branch_signal == 1) begin
            PC = PC + 1 + $signed(immediate); 
        end
        else begin
            PC = PC+1;
        end
    end 
endmodule