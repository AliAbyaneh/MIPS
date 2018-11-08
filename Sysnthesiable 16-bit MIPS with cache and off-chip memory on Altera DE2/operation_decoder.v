// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module operation_decoder (op_code, BZ, imm_inst);
	input [3:0] op_code;
	output BZ, imm_inst;
	assign imm_inst = (op_code == 4'b1001 || op_code == 4'b1011 || op_code == 4'b1010) ? 1 : 0 ;
	assign BZ = (op_code == 4'b1100) ? 1 : 0;

	endmodule
