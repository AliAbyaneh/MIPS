// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture
// MIPS high-level Verilog Implementation 
module MIPS(clk,rst);
  input clk,rst;
  
  wire [2:0] ex;
  wire [1:0] m,aluop;
  wire [5:0] wb,opc;
  wire jalsel,regdst,pctoreg,uppersel,alusrc,memtoreg,writemem,readmem,regwrite,branch,jumpsel,zero;
  datapath A(clk,rst,ex,m,wb,branch,jumpsel,opc,zero);
  controller B(jalsel,regdst,pctoreg,uppersel,alusrc,aluop,memtoreg,writemem,readmem,regwrite,branch,jumpsel,zero,opc);
  assign m={writemem, readmem};
  assign ex={aluop,alusrc};
  assign wb={memtoreg,pctoreg,uppersel,regwrite,jalsel,regdst};
  
endmodule
  
