// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module reg_mux (select , in_0 , in_1 , w);
	input select ;
	input [2:0] in_0 , in_1 ;
	output [2:0] w ;
	assign w = (select) ? in_1 : in_0 ;
endmodule
