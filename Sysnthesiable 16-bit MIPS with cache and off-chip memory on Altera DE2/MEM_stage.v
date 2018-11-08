// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module MEM_stage (clk , rst , pipeline_reg_in , pipeline_reg_out , mem_op_dest, mem_res, opc_in, opc_out,
						CLOCK_50, SRAM_DATA, SRAM_ADDRESS, SRAM_UB_N_O, SRAM_LB_N_O, SRAM_WE_N_O, SRAM_CE_N_O, SRAM_OE_N_O, memory_stall);
	//SRAM controller
	input CLOCK_50;
	//to the memory stage unit
	wire [17:0] SRAM_address;
	wire [15:0] SRAM_write_data;
	wire SRAM_we;
	wire [15:0] SRAM_read_data;
	wire ready;

	// To the SRAM pins
	inout [15:0] SRAM_DATA;
	output [17:0] SRAM_ADDRESS;
	output SRAM_UB_N_O; //GND
	output SRAM_LB_N_O; //GND
	output SRAM_WE_N_O;
	output SRAM_CE_N_O; //GND
	output SRAM_OE_N_O;//GND
	//clock enable
	output memory_stall;



	input clk , rst;
	//from EX_stage
	input [37:0] pipeline_reg_in;
	// to WB_stage
	output reg [36:0] pipeline_reg_out;
		//[36:21] , 16 bits : ex_alu_result[15:0]
		// [20:5] , 16 bits : mem_read_data [15:0]
		// [4:0] , 5 bits : write_back_en, write_back_dest[2:0 , write_back_result_mux
	// to hazard detection unit
	output [2:0] mem_op_dest;

	//Forwarded data
	output [15:0] mem_res;
	input [3:0] opc_in;
	output reg [3:0] opc_out;

	wire [15:0] ex_alu_result;
	wire [15:0] mem_read_data ;
	wire write_back_en ;
	wire [2:0] write_back_dest;
	wire write_back_result_mux;

	//forwarding
	assign mem_res = (write_back_result_mux)? mem_read_data : ex_alu_result;

	assign write_back_result_mux = pipeline_reg_in[0];
	assign ex_alu_result = pipeline_reg_in [37:22];
	assign write_back_en = pipeline_reg_in[4];
	assign write_back_dest = pipeline_reg_in[3:1];

	assign SRAM_address = {3'b0, pipeline_reg_in[37:22]};
	assign SRAM_write_data = pipeline_reg_in[20:5];
	assign SRAM_we = pipeline_reg_in[21];


	SRAM_controller MIPS_SRAM_controller(
														.clk(CLOCK_50),
														.rst(rst),
														.SRAM_address(SRAM_address),
														.SRAM_write_data(SRAM_write_data),
														.SRAM_we(SRAM_we),
														.SRAM_read_data(SRAM_read_data),
														.ready(ready),
														.SRAM_DATA(SRAM_DATA),
														.SRAM_ADDRESS(SRAM_ADDRESS),
														.SRAM_UB_N_O(SRAM_UB_N_O),
														.SRAM_LB_N_O(SRAM_LB_N_O),
														.SRAM_WE_N_O(SRAM_WE_N_O),
														.SRAM_CE_N_O(SRAM_CE_N_O),
														.SRAM_OE_N_O(SRAM_OE_N_O)
														);

	wire [15:0] cache_read_data;
	wire memory_stall_cache;
	assign memory_stall = memory_stall_cache;
	wire hit;
	wire [3:0] cache_opc;
	assign cache_opc = opc_in;
	cache_controller MIPS_cache(
	                             .clk(clk),
	                             .rst(rst),
	                             .read_data(cache_read_data),
	                             .write_data_from_mem(SRAM_read_data),
	                             .write_data_from_core(pipeline_reg_in[20:5]),
	                             .memory_stall(memory_stall_cache),
	                             .address(pipeline_reg_in[37:22]),
	                             .hit(hit),
	                             .opc(cache_opc)
	                           );
	assign mem_read_data = (hit == 1'b1) ? cache_read_data : SRAM_read_data;
	//memory MIPS_memory (pipeline_reg_in[37:22], SRAM_read_data, pipeline_reg_in[20:5], pipeline_reg_in[21], 1'b1, rst, clk);
	//to HD unit
	assign mem_op_dest = write_back_dest;


	always @(posedge clk , posedge rst)
	begin
		if(rst)begin
			pipeline_reg_out = 37'b0;
			opc_out = 4'b0;
		end
		else if(memory_stall_cache)begin
		  pipeline_reg_out = 37'b0;
		  opc_out = 4'b0;
		end
		else begin
			//pipeline_reg_out = {22'b0, pipeline_reg_in[15:0]};
			pipeline_reg_out = {ex_alu_result,mem_read_data,write_back_en,write_back_dest,write_back_result_mux};
	    opc_out = opc_in;
	  end
	end

endmodule
