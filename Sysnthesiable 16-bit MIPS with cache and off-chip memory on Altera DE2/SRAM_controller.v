// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module SRAM_controller(
								input clk,
								input rst,
								//to the memory stage unit
								input [17:0] SRAM_address,
								input [15:0] SRAM_write_data,
								input SRAM_we,
								output [15:0] SRAM_read_data,
								output ready,

								// To the SRAM pins
								inout reg [15:0] SRAM_DATA,
								output reg [17:0] SRAM_ADDRESS,
								output reg SRAM_UB_N_O, //GND
								output reg SRAM_LB_N_O, //GND
								output reg SRAM_WE_N_O,
								output reg SRAM_CE_N_O, //GND
								output reg SRAM_OE_N_O //GND
							);
	assign SRAM_read_data = (SRAM_we) ? 16'b0 : SRAM_DATA;
	always@(posedge clk)
	begin
		if(rst)
		begin
			SRAM_DATA = 16'bz;
			SRAM_ADDRESS = 16'b0;
			SRAM_WE_N_O = 1'b1;
		end
		else if(SRAM_we)
		begin
			SRAM_WE_N_O = 1'b0;
			SRAM_ADDRESS = SRAM_address;
			SRAM_DATA = SRAM_write_data;
		end
		else
		begin
			SRAM_WE_N_O = 1'b1;
			SRAM_DATA = 16'bz;
			SRAM_ADDRESS = SRAM_address;
		end
		SRAM_UB_N_O = 1'b0;
		SRAM_LB_N_O = 1'b0;
		SRAM_CE_N_O = 1'b0;
		SRAM_CE_N_O = 1'b0;

	end



endmodule
