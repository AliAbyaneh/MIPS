module hi_lo_reg(hiIn, loIn, clk, rst, write, readReg, readData);
  input [31:0] hiIn, loIn;
  input clk, rst, write, readReg;
  output [31:0] readData;
  reg [31:0] hiloReg [0:1];
  assign readData = hiloReg[readReg];
  always @(posedge clk)
  begin
    if(rst)
    begin
      hiloReg[0] = 32'b0;
      hiloReg[1] = 32'b0;
    end
    else if(write)
    begin
      hiloReg[0] = loIn;
      hiloReg[1] = hiIn;
    end
  end
endmodule 
