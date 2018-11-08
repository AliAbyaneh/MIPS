// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module multiplexer_2 (select , in_0 , in_1 , w);
	input select ;
	input [15:0] in_0 , in_1 ;
	output [15:0] w ;
	assign w = (select) ? in_1 : in_0 ;
endmodule
