// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture

module IFID(PC4, inst, write, flush, clk, rst, PC4o, insto);
  input [31:0] PC4, inst;
  input clk, rst, flush, write;
  output reg [31:0] PC4o, insto;
  //reg [31:0] PCReg,instReg;
  always @ (posedge clk)
  begin
    if(rst) begin
      PC4o = 32'b0;
      insto = 32'b0;
    end
   else if(write) begin
      PC4o = PC4;
      insto = inst;
    end
  end
  always @ (negedge clk)begin
    if(flush) begin
      PC4o = 32'b0;
      insto = 32'b0;
    end
  end
endmodule
