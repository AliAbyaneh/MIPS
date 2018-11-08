// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module WB_stage (pipeline_reg_in , reg_write_en, reg_write_dest , reg_write_data , wb_op_dest);
	//from EX_stage
	input [36:0] pipeline_reg_in;
	// to register file
	output reg_write_en;
	output [2:0] reg_write_dest;
	output [15:0] reg_write_data;
	// to hazard detection unit
	output [2:0] wb_op_dest;

	assign wb_op_dest = reg_write_dest;

	multiplexer_2 MIPS_multiplexer_2(.in_0(pipeline_reg_in[36:21]), .in_1(pipeline_reg_in[20:5]), .select(pipeline_reg_in[0]), .w(reg_write_data));
	assign reg_write_dest = pipeline_reg_in [3:1];
	assign reg_write_en = pipeline_reg_in[4];

endmodule
