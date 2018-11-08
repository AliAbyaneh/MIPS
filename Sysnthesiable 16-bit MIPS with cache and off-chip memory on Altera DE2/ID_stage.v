// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module ID_stage ( clk , rst , instruction_decode_en , pipeline_reg_out ,
						instruction , branch_offset_imm , branch_taken , reg_read_addr_1 ,
						reg_read_addr_2 , reg_read_data_1 , reg_read_data_2 , decoding_op_src1 , decoding_op_src2, stall
						,forward_A, forward_B, ex_rd_val, mem_rd_val, wb_rd_val, opc_out, memory_stall);

	input clk , rst, instruction_decode_en, stall;
	// to EX_stage
	output reg [57:0] pipeline_reg_out;
		// [57:22] ,35 bit:  ex_alu_cmd[2:0] , ex_alu_src1 [15:0] , ex_alu_src2 [15:0]
		// [21:5] mem_write_en , mem_write_data[15:0]
		// [4:0] write_back_en , write_back_dest [2:0] , write_back_rsult_mux.
	// to IF_stage
	input [15:0]  instruction;
	output [5:0] branch_offset_imm;
	output branch_taken;
	// to register file
	output [2:0] reg_read_addr_1;
	output [2:0] reg_read_addr_2;
	input [15:0] reg_read_data_1;
	input [15:0] reg_read_data_2;
	// to hazard detection unit
	output [2:0] decoding_op_src1;
	output [2:0] decoding_op_src2;

	//Forwarded data
	input [15:0] ex_rd_val, mem_rd_val, wb_rd_val;
	input [1:0] forward_A, forward_B;
	output reg [3:0] opc_out;

	input memory_stall;

	wire [3:0] ex_alu_cmd;
	wire [15:0] ex_alu_src1, ex_alu_src2;
	wire [15:0] id_ex_alu_src1, id_ex_alu_src2;
	wire mem_write_en;
	wire [15:0] mem_write_data;
	wire write_back_en;
	wire [2:0] write_back_dest;
	wire write_back_result_mux;
	wire zero_flag;
	wire branch_inst;
	wire imm_inst;
	wire [15:0] signed_imm;
	reg bad_inst;
	//wire [15:0] valid_inst;
	wire [3:0] opc;
	assign opc = (bad_inst) ? 4'b0000 : instruction[15:12];
	assign write_back_dest = instruction[11:9];
	//reg file read mux in case of ST(store) instruction
	assign reg_read_addr_1 = instruction[8:6];
	assign reg_read_addr_2 = (opc == 4'b1011) ? instruction [11:9] : instruction[5:3];
	assign id_ex_alu_src1 = reg_read_data_1;
	assign mem_write_data = id_ex_alu_src2;
	sign_extend MIPS_SE(instruction[5:0], signed_imm);
	assign ex_alu_src2 = (imm_inst)? signed_imm : id_ex_alu_src2;
	//assign write_back_result_mux = 1'b0;
	assign mem_write_en = (opc == 4'b1011) ? 1'b1 : 1'b0;
	assign write_back_result_mux = (opc == 4'b1010) ? 1'b1 : 1'b0;
	alu_cmd_handler MIPS_alu_cmd_handler(.alu_cmd(ex_alu_cmd), .opcode(opc));
	write_handler MIPS_write_handler (write_back_dest, write_back_en, opc);

	zero_comp MIPS_zero_comp(ex_alu_src1, zero_flag);

	operation_decoder MIPS_op_decoder(opc, branch_inst, imm_inst);


	//Forwarding MUXs

	mux4to1 MIPS_MUX_A(.a(id_ex_alu_src1), .b(ex_rd_val), .c(mem_rd_val), .d(wb_rd_val), .sel(forward_A), .w(ex_alu_src1));
	mux4to1 MIPS_MUX_B(.a(reg_read_data_2), .b(ex_rd_val), .c(mem_rd_val), .d(wb_rd_val), .sel(forward_B), .w(id_ex_alu_src2));

	assign branch_offset_imm = instruction [5:0];

	assign branch_taken = (branch_inst && zero_flag) ? 1'b1 : 1'b0;


	always @ (posedge clk)begin
		if(rst)begin
			pipeline_reg_out = 58'b0;
			bad_inst = 1'b0;
			opc_out = 4'b0;
		end
		else if (stall && ~memory_stall)begin
		    pipeline_reg_out = 58'b0;
		    opc_out = 4'b0;
		end
		else if(~stall && ~memory_stall) begin
			pipeline_reg_out = {	ex_alu_cmd, ex_alu_src1, ex_alu_src2, mem_write_en, mem_write_data, write_back_en, write_back_dest, write_back_result_mux};
      opc_out = opc;
      bad_inst = branch_taken;
			//pipeline_reg_out = {42'b0, instruction};
		end

	end

endmodule
