// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module alu_cmd_handler(opcode, alu_cmd);
	input [3:0] opcode;
	output reg[3:0] alu_cmd;
	always @(*)begin
		case(opcode)
			4'b0000: alu_cmd = 4'b0000;
			4'b0001: alu_cmd = 4'b0000;
			4'b0010: alu_cmd = 4'b0001;
			4'b0011: alu_cmd = 4'b0010;
			4'b0100: alu_cmd = 4'b0011;
			4'b0101: alu_cmd = 4'b0100;
			4'b0110: alu_cmd = 4'b0101;
			4'b0111: alu_cmd = 4'b0110;
			4'b1000: alu_cmd = 4'b0111;
			4'b1001: alu_cmd = 4'b0000;
			4'b1010: alu_cmd = 4'b0000;
			4'b1011: alu_cmd = 4'b0000;
			4'b1100: alu_cmd = 4'b0000;
			4'b1101: alu_cmd = 4'b1000;
			default:alu_cmd = 4'b0000;
		endcase
	end
endmodule
