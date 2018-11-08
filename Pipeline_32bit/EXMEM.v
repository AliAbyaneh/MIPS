// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture
// Execution Memory Implementation 

module EXMEM(M, WB, PC4, res, readData2, RCT, inst, hilo, write, flush, clk, rst, Mo, WBo, PC4o, reso, readData2o, RCTo, insto, hiloo);
  input [1:0] M;
  input [5:0] WB;
  input [31:0] PC4, res, readData2;
  input [2:0] RCT;
  input [31:0] inst, hilo;
  input write, flush, clk, rst;
  output reg [1:0] Mo;
  output reg [5:0] WBo;
  output reg [31:0] PC4o, reso, readData2o;
  output reg [2:0] RCTo;
  output reg [31:0] insto, hiloo;
  always @ (posedge clk or posedge flush) begin
    if(rst || flush) begin
      Mo = 2'b0;
      WBo = 6'b0;
      PC4o = 32'b0;
      reso = 32'b0;
      readData2o = 31'b0;
      RCTo = 3'b0;
      insto = 32'b0;
      hiloo = 32'b0;
    end
    else if(write) begin
      Mo = M;
      WBo = WB;
      PC4o = PC4;
      reso = res;
      readData2o = readData2;
      RCTo = RCT;
      insto = inst;
      hiloo = hilo;
    end
  end  
endmodule
