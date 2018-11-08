// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module EX_stage ( clk , rst , pipeline_reg_in , pipeline_reg_out , ex_op_dest, ex_res, opc_in, opc_out, memory_stall);

	input clk , rst;
		// from ID_stage
	input [57:0] pipeline_reg_in ;
		// to MEM_stage
	output reg [37:0] pipeline_reg_out;
		// [37:22] , 16 bits : ex_alu_result
		// [21:5] , 17 bits : mem_write_en , mem_write_data
		// [4:0] write_back_en,write_back_dest [2:0] , write_back_result_mux
 	// too HD_unit
	output [2:0] ex_op_dest;
	//Forwarding data
	output [15:0] ex_res;
	input [3:0] opc_in;
	output reg[3:0] opc_out;

	input memory_stall;

	wire [15 : 0] ex_alu_result;
	wire mem_write_en;
	wire [15:0] mem_write_data;
	wire write_back_en ;
	wire [2:0] write_back_dest ;
	wire write_back_result_mux ;
	//forwarding
	assign ex_res = ex_alu_result;

	assign mem_write_en = pipeline_reg_in[21];
	assign mem_write_data = pipeline_reg_in[20:5];
	assign write_back_en = pipeline_reg_in[4];
	assign write_back_dest = pipeline_reg_in[3:1];
	assign write_back_result_mux = pipeline_reg_in[0];
	alu MIPS_alu(.r(ex_alu_result), .b(pipeline_reg_in[37:22]), .a(pipeline_reg_in[53:38]), .cmd(pipeline_reg_in[57:54]));


	assign ex_op_dest = write_back_dest;
	//alu MIPS_alu(.r(ex_alu_result), .b(16'd4), .a(16'd18), .cmd(3'b000));

	always @(posedge clk , posedge rst)
	begin
		if(rst)begin
			pipeline_reg_out = 38'b0;
	    opc_out = 4'b0;
	 	end
		else if(~memory_stall)begin
			//pipeline_reg_out = {23'b0, pipeline_reg_in[15:0]};
			pipeline_reg_out = {ex_alu_result , mem_write_en , mem_write_data , write_back_en , write_back_dest , write_back_result_mux};
		  opc_out = opc_in;
		end
	end
endmodule
