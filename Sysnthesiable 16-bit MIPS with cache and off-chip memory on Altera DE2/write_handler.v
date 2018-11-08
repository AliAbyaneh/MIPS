// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module write_handler (write_address , write_en_out , opc);
	input [2:0] write_address ;
	output write_en_out ;
	input [3:0] opc;

	wire adr_and ;
	assign adr_and = |write_address ;
	assign write_en_out =(opc == 4'b1011 || opc == 4'b1100 || opc == 4'b0000) ? 1'b0 : adr_and;

endmodule
