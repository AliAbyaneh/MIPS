// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module MIPS(CLOCK_50,  SW, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
	input CLOCK_50;
	input [17:0] SW;



	// To the SRAM pins
	inout [15:0] SRAM_DQ;
	output [17:0] SRAM_ADDR;
	output SRAM_UB_N; //GND
	output SRAM_LB_N; //GND
	output SRAM_WE_N;
	output SRAM_CE_N; //GND
	output SRAM_OE_N;//GND

	wire clk, rst;

	assign clk = CLOCK_50;
	assign rst = SW[0];
	//IF stage wires
		wire instr_fetch_enable;
		wire branch_enable;
		wire [5:0] imm_branch_offset;
		wire [7:0] pc;
		wire [15:0] instr;
	//ID stage wires
		wire instruction_decod_en;
		// to EX_stage
		wire [57:0] pipeline_reg_out_id;
			// [57:22] ,35 bit:  ex_alu_cmd[2:0] , ex_alu_src1 [15:0] , ex_alu_src2 [15:0]
			// [21:5] mem_write_en , mem_write_data[15:0]
			// [4:0] write_back_en , write_back_dest [2:0] , write_back_rsult_mux.
		// to IF_stage
		wire [15:0]  instruction;
		wire [5:0] branch_offset_imm;
		wire branch_taken;
		// to register file
		wire [2:0] reg_read_addr_1;
		wire [2:0] reg_read_addr_2;
		wire [15:0] reg_read_data_1;
		wire [15:0] reg_read_data_2;
		// to hazard detection unit
		wire [2:0] decoding_op_src1;
		wire [2:0] decoding_op_src2;

	//EX stage wires
			// from ID_stage
		wire [57:0] pipeline_reg_in_ex ;
			// to MEM_stage
		wire [37:0] pipeline_reg_out_ex;
			// [37:22] , 16 bits : ex_alu_result
			// [21:5] , 17 bits : mem_write_en , mem_write_data
			// [4:0] write_back_en,write_back_dest [2:0] , write_back_result_mux
		// too HD_unit
		wire [2:0] ex_op_dest;
	//MEM stage wires
		wire [37:0] pipeline_reg_in_mem;
		// to WB_stage
		wire [36:0] pipeline_reg_out_mem;
			//[36:21] , 16 bits : ex_alu_result[15:0]
			// [20:5] , 16 bits : mem_read_data [15:0]
			// [4:0] , 5 bits : write_back_en, write_back_dest[2:0 , write_back_result_mux
		// to hazard detection unit
		wire [2:0] mem_op_dest;
	//WB stage wires
		//from EX_stage
		wire [36:0] pipeline_reg_in_wb;
		// to register file
		wire reg_write_en;
		wire [2:0] reg_write_dest;
		wire [15:0] reg_write_data;
		// to hazard detection unit
		wire [2:0] wb_op_dest;
		wire stall;
    //forwarding
    wire [15:0] ex_rd_val, mem_rd_val, wb_rd_val;
    wire [1:0] forward_A, forward_B;
    wire [3:0] ex_opc;
    wire [3:0] mem_opc;
    wire [3:0] wb_opc;


    wire [3:0] ex_opc_in, ex_opc_out, mem_opc_in, mem_opc_out;

    assign ex_opc_in = ex_opc;
    assign mem_opc_in = ex_opc_out;
    assign wb_opc = mem_opc_out;

    assign mem_opc = mem_opc_in;

    assign wb_rd_val = reg_write_data;
	wire memory_stall;
	assign instr_fetch_enable = ~stall && ~memory_stall;
	assign instruction = instr;
	assign pipeline_reg_in_ex = pipeline_reg_out_id;
	assign pipeline_reg_in_mem =  pipeline_reg_out_ex;
	assign pipeline_reg_in_wb = pipeline_reg_out_mem;
	//assign pipeline_reg_in = pipeline_reg_out_mem;
	assign imm_branch_offset = branch_offset_imm;
	assign branch_enable = branch_taken;

	/*SRAM_access_handler MIPS_mem_acces(
                                      .clk(clk),
                                      .opc(mem_opc),
                                      .rst(rst),
                                      .stall(memory_stall)
                                    );
  */
	hazard_detection MIPS_hazard_detection (
	                                         .stall(stall), .rs1(reg_read_addr_1), .rs2(reg_read_addr_2),
	                                         .rd_ex(ex_op_dest), .rd_mem(mem_op_dest), .rd_wb (wb_op_dest),
	                                         .forward_en(1'b1), .forward_A(forward_A), .forward_B(forward_B),
	                                         .opc_ex(ex_opc), .opc_id(instr[15:12]), .opc_mem(mem_opc),
	                                         .opc_wb(wb_opc));

	IF_stage MIPS_ifstage( clk , rst , instr_fetch_enable , imm_branch_offset , branch_enable , pc , instr);
	ID_stage MIPS_idstage( clk , rst , instruction_decod , pipeline_reg_out_id , instruction , branch_offset_imm , branch_taken , reg_read_addr_1 , reg_read_addr_2 , reg_read_data_1 , reg_read_data_2 , decoding_op_src1 , decoding_op_src2, stall, forward_A, forward_B, ex_rd_val, mem_rd_val, wb_rd_val, ex_opc, memory_stall);

	EX_stage MIPS_exstage( clk , rst , pipeline_reg_in_ex , pipeline_reg_out_ex , ex_op_dest, ex_rd_val, ex_opc_in, ex_opc_out, memory_stall);

	MEM_stage MIPS_memstage(clk , rst , pipeline_reg_in_mem , pipeline_reg_out_mem , mem_op_dest, mem_rd_val,mem_opc_in, mem_opc_out, CLOCK_50, SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N, memory_stall);

	WB_stage MIPS_wbstage(pipeline_reg_in_wb , reg_write_en, reg_write_dest , reg_write_data , wb_op_dest);
	//reg_file MIPS_regfile(clk, 1'b0, reg_read_addr_1, reg_read_addr_2, 3'd2, 16'd02, reg_read_data_1, reg_read_data_2, 1'b1);
	reg_file MIPS_regfile(clk, SW[0], reg_read_addr_1, reg_read_addr_2, reg_write_dest, reg_write_data, reg_read_data_1, reg_read_data_2, reg_write_en);
endmodule
