// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module adder (in1, in2 , result);
	input [7:0] in1, in2 ;
	output [7:0] result;
	assign result = in1 + in2;
endmodule
