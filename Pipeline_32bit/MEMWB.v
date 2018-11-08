module MEMWB (WB, PC4, memData, res, RCT, inst, hilo, write, flush, clk, rst, WBo, PC4o, memDatao, reso, RCTo, insto, hiloo);
  input [5:0] WB;
  input [31:0] PC4,memData, res;
  input [2:0] RCT;
  input [31:0] inst, hilo;
  input write, flush, clk, rst;
  output reg [5:0] WBo;
  output reg [31:0] PC4o, memDatao, reso;
  output reg [2:0] RCTo;
  output reg [31:0] insto, hiloo;
  always @(posedge clk or posedge flush) begin
    if(rst || flush) begin
      WBo = 6'b0;
      PC4o = 32'b0;
      memDatao = 32'b0;
      reso = 32'b0;
      RCTo = 3'b0;
      insto = 32'b0;
      hiloo = 32'b0;
    end
    else if(write) begin
      WBo = WB;
      PC4o = PC4;
      memDatao = memData;
      reso = res;
      RCTo = RCT;
      insto = inst;
      hiloo = hilo;
    end
  end
endmodule