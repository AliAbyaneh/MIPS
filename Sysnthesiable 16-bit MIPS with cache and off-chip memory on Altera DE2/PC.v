// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module PC (clock , reset , in , write , w);
input clock , reset , write ;
input [7:0] in;
output reg [7:0] w;
always @(posedge clock)
	begin
		if(reset)
			w = 8'b0 ;
		else if (write)
			w = in;

	end
endmodule
