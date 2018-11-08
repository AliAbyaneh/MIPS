// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module SRAM_access_handler(opc, rst, clk, stall);
	parameter BITS = 2;

	input [3:0] opc;
	input clk, rst;
	output stall;
	wire access_en;
	assign access_en = ((opc == 4'b1010) || (opc == 4'b1011)) ? 1'b1 : 1'b0;

	reg [BITS - 1 : 0] count;


	always @(posedge clk)
	begin
		if(rst)
		begin
			count = {(BITS){1'b0}};
		end
		else if(access_en)
		begin
			count = count + 1;
		end
	end
	assign stall = (access_en && count != {(BITS){1'b1}}) ? 1'b1 : 1'b0;

endmodule
