// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module IF_stage ( clk , rst , instr_fetch_enable , imm_branch_offset , branch_enable , pc , instr);
	input clk , rst, instr_fetch_enable , branch_enable;
	input [5:0] imm_branch_offset;
	output [7:0] pc;
	output [15:0] instr;




	wire [7:0] pc_in, pc_out;
	wire [15:0] rom_out;

	wire [7:0] pc_pipe_in;
	wire [15:0] instr_pipe_in;
	wire [7:0] pc_add_in;
	wire [15:0] signed_imm_branch_offset;
	sign_extend MIPS_BRACNH_ADDR(imm_branch_offset, signed_imm_branch_offset);

	assign pc_add_in = (branch_enable) ? signed_imm_branch_offset : 8'd1;

	PC MIPS_pc (.clock(clk), .reset(rst), .write(instr_fetch_enable), .in(pc_in), .w(pc_out));
	INST_ROM MIPS_rom(.adr(pc_out), .en(1'b1), .inst(rom_out));
	adder MIPS_adder(.in1(pc_out), .in2(pc_add_in) , .result(pc_in));


	//IFID pipe reg
	reg [23:0] pipe_reg;
	always@(posedge clk, posedge rst)
	begin
		if(rst)
			pipe_reg = 24'b0;
		else
		begin
		  if(instr_fetch_enable)
			 pipe_reg = {pc_out, rom_out};
		end
	end


	assign instr = pipe_reg[15:0];
	assign pc = pipe_reg[23:16];

endmodule
