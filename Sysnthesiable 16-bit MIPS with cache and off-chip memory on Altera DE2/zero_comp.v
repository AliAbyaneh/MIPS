// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module zero_comp (rs, comp);
	input [15:0] rs;
	output comp;

	assign comp = (rs == 16'd0) ? 1'b1 : 1'b0;

	endmodule
