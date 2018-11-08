// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module reg_file (clock ,reset, read_address_1, read_address_2, write_address ,write_data , read_data_1 , read_data_2 ,write_en);
	input clock , reset , write_en;
	input [2:0] read_address_1 , read_address_2 , write_address;
	input [15:0] write_data;
	output [15:0] read_data_1 , read_data_2 ;

	reg [15:0] REG [7:0];
	always @(posedge clock , posedge reset)
	begin
		if (reset)
			begin
				REG[0] = 16'd0;
				REG[1] = 16'd0;
				REG[2] = 16'd0;
				REG[3] = 16'd0;
				REG[4] = 16'd0;
				REG[5] = 16'd0;
				REG[6] = 16'd0;
				REG[7] = 16'd0;
			end
		else if(write_en)
			REG[write_address] = write_data;
	end

	assign read_data_1 = REG[read_address_1];
	assign read_data_2 = REG[read_address_2];




endmodule
