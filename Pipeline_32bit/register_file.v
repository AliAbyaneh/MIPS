// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture

module register_file(ReadReg1, ReadReg2, WriteReg, WriteData, RegWrite, clk, rst, ReadData1, ReadData2);
  input [4:0] ReadReg1, ReadReg2, WriteReg;
  input [31:0] WriteData;
  input RegWrite, clk, rst;
  output [31:0] ReadData1, ReadData2;
  
  reg [31:0] regFile [0:31];
  
  assign ReadData1 = regFile[ReadReg1];
  assign ReadData2 = regFile[ReadReg2];
  
  integer i;
  always @ (posedge clk)
  begin
    if(rst)
      for(i = 0; i < 32; i = i + 1)
        regFile[i] = 32'b0;
    /*else if(RegWrite)
        regFile[WriteReg] = (WriteReg != 32'b0) ? WriteData:32'b0;*/
  end
  always @ (negedge clk)
    if(RegWrite)
      regFile[WriteReg] = (WriteReg != 32'b0) ? WriteData:32'b0;
endmodule
