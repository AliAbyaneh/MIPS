// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module alu (a, b, cmd, r);
	input [15:0] a, b;
	input [3:0] cmd;
	reg [15:0] res;
	output [15:0] r;
	always@(*)begin
		case(cmd)
			4'b0000: res = a + b;
			4'b0001: res = a - b;
			4'b0010: res = a & b;
			4'b0011: res = a | b;
			4'b0100: res = a ^ b;
			4'b0101: res = a << b;
			4'b0110: res = a >> b;
			4'b0111: res = a >>> b;
			4'b1000: res = ( a > b) ? 16'd0: 16'd1;
			default:res = 16'b0;
		endcase

	end
	assign r = res;
endmodule
