/* Test Module designed to read the instructions from a .mem file containing the 32-bit MIPS instructions
   in binary
*/
module read_instructions(instruction, program_counter);

    input [31:0] program_counter;
    output reg [31:0] instruction;
	
    reg [31:0] instructions [255:0];  //set to the number of instructions in the file
	
    initial begin 
        $readmemb("instruction.mem", instructions); 
    end
	
    always @ (program_counter) begin
        instruction = instructions[program_counter];
    end

endmodule

