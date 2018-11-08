// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module cache(write_data, read_data, write_en, address, clk, rst);
  parameter size = 16;
  input [size - 1:0] write_data;
  input [7:0] address;
  output [size -1:0] read_data;
  input clk, write_en, rst;
  reg [size - 1:0] cache [0:255];
  assign read_data = cache[address];
  integer i;
  always @(posedge clk)
  begin
	if(write_en)
    begin
      cache [address] = write_data;
    end
  end

endmodule
