// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module memory(adr, mem_read_data, mem_write_data, write_en, read_en, rst, clk);
  input [7:0] adr;
  input rst, clk, read_en, write_en;
  input [15:0] mem_write_data;
  output [15:0] mem_read_data;

  reg [15:0] mem [0:255];
  always @(posedge clk, posedge rst)
  begin
    if(rst)
      begin


      end
      else if (write_en)
        mem[adr] = mem_write_data;
  end
  assign mem_read_data = (read_en) ? mem [adr] : 16'b0;

endmodule
