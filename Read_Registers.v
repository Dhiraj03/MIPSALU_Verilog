/* Module to read the 32-bit registers and read/write according to the 
   RegWrite an RegRead signals
*/
module read_registers(
    output reg [31:0] read_data_1, read_data_2,   // The output are two 32-bit binary numbers that contain the data stored in RS and RT
    input [31:0] write_data,   // The data to be written
    input [4:0] rs, rt, rd,    // RS and RT are the read registers and RD (Destination register) is the write register
    input [5:0] opcode,        // The 6-bit opcode of the instruction
    input RegRead, RegWrite, RegDst   // RegRead and RegWrite are signals that indicate whether the instruction needs to read from registers and/or write to a register
);

    reg [31:0] registers [31:0];    // The set of 32 registers (32-bit)
	
    initial begin
        $readmemb("registers.mem", registers, 31, 0);   //Reads all the values stored in the 32 registers
    end
	
    always @(write_data) begin    // If a change in the data to be written is noticed
        if(RegWrite) begin
            /* RegWrite = 0 => Write to RT
               RegWrite = 1 => Write to RD
            */
            if(RegDst) begin
                if(opcode == 6'h24)begin    // LBU(load byte unsigned) or LHU (Load halfword unsigned)
                    registers[rd][7:0] = write_data[7:0];
                end
                if(opcode == 6'h25)begin
                    registers[rd][15:0] = write_data[15:0];
                end
                else begin   // LL(Load linked)
                    registers[rd] = write_data;
                end
            end
            else begin
                if(opcode == 6'h24)begin
                    registers[rt][7:0] = write_data[7:0];
                end
                if(opcode == 6'h25)begin
                    registers[rt][15:0] = write_data[15:0];
                end
                else begin
                    registers[rt] = write_data;
                end
            end
            // Write back the updated values to the registers file
            $writememb("registers.mem",registers,31,0);
        end
    end
	
    always @(rs,rt) begin
        // Read from registers
        if(RegRead) begin
            read_data_1 = registers[rs];
            read_data_2 = registers[rt];
        end
    end
endmodule