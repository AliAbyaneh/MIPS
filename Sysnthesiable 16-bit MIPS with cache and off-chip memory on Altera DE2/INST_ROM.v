// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module INST_ROM(adr, inst, en);

	input [7:0] adr;
	input en;
	output [15:0] inst;
	reg [15:0] rom [0:255];
	assign inst =(en) ? rom[adr]:16'b0;
	always @(adr, inst, en) begin
		//$readmemb("inst.bin", rom);
    //Cache Testbench
    rom[0] = 16'b1001111000000001; // addi R7,1	R7 = 1
		rom[1] = 16'b1001110000001000; // addi R6,8	R6 = 8
		rom[2] = 16'b1001101000001001; // addi R5,9    R5 = 9
		rom[3] = 16'b0110001111110000; // shl R1,R7,R6  R1 = 256
		rom[4] = 16'b0110010111101000; // shl R2,R7,R5  R2 = 512
		rom[5] = 16'b1001011000000001; // addi R3,1   R3 = 1
		rom[6] = 16'b1011011001000000; // ST [R1,0], R3
		rom[7] = 16'b1011000000000000; // ST[R0,0], R0
		rom[8] = 16'b1001011000000010; // addi R3,2 R3 = 2
		rom[9] = 16'b1011011010000000; // ST[R0,0], R0
		rom[10] = 16'b1010011001000000; // LD R3,[R1,0] R3 = 1
		rom[11] = 16'b1010011000000000; // LD R3,[R0,0] R3 = 0
		rom[12] = 16'b1010011001000000; // LD R3,[R1,0] R3 = 1
		rom[13] = 16'b1010011010000000; // LD R3,[R2,0] R3 = ?
		rom[14] = 16'b1001011000000100; // addi R3,4 R3 = 4
		rom[15] = 16'b1011011001000000; // ST[R1,0], R3
		rom[16] = 16'b1010011000000000; // LD R3,[R0,0] R3 = 0
		rom[17] = 16'b0000000000000000;
		rom[18] = 16'b0000000000000000;
		rom[19] = 16'b0000000000000000;
		rom[20] = 16'b0000000000000000;
  end
endmodule
