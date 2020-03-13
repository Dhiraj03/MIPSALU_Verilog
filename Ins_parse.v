/* Module designed to read the instruction and assign the various
   components of the instruction to suitable variables depending on the format
*/
module ins_parse(
    output wire [5:0] opcode,
    output reg [4:0] rs, rt, rd, shamt, 
    output reg [5:0] funct,
    output reg[15:0] immediate,
    output reg [25:0] address,
    input [31:0] instruction, p_count
);

    assign opcode = instruction[31:26];
	
    always @(instruction) begin
        if(opcode == 6'h0) 
        begin        //R-type 
            shamt = instruction[10:6];
            rd = instruction[15:11];
            rt = instruction[20:16];
            rs = instruction[25:21];
            funct = instruction[5:0];
        end
        else if(opcode == 6'h2 | opcode == 6'h3) 
        begin   // J-type
            address = instruction[25:0];
        end
        else 
        begin                               // I-type
            rt = instruction[20:16];
            rs = instruction[25:21];
            immediate = instruction[15:0];
        end
    end
	
endmodule