module IDEXE(EX, M, WB, PC4, readData1, readData2, inst, branch, write, flush, clk, rst, EXo, Mo, WBo, PC4o, readData1o, readData2o, insto, brancho);
  input [2:0] EX;
  input [1:0] M;
  input [5:0] WB;
  input [31:0] PC4, readData1, readData2, inst;
  input branch;
  input write, flush, clk, rst;
  output reg [2:0] EXo;
  output reg [1:0] Mo;
  output reg [5:0] WBo;
  output reg [31:0] PC4o, readData1o, readData2o, insto;
  output reg brancho;
  always @(posedge clk or posedge flush) begin
    if(rst || flush) begin
      EXo = 3'b0;
      Mo = 2'b0;
      WBo = 6'b0;
      PC4o = 31'b0;
      readData1o = 31'b0;
      readData2o = 31'b0;
      insto = 31'b0;
      brancho = 1'b0;
    end
    else if(write) begin
      EXo = EX;
      Mo = M;
      WBo = WB;
      PC4o = PC4;
      readData1o = readData1;
      readData2o = readData2;
      insto = inst;
      brancho = branch;
    end
  end 
endmodule
  
