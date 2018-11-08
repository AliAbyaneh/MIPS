module controller (jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel,zero,opc);
  output reg jalsel,regdst,Pctoreg,uppersel,ALUsrc,Memtoreg,writemem,readmem,regwrite,branch,jumpsel;
  output reg [1:0] ALUop;
  input zero;
  input [5:0] opc;
  always @(opc,zero)
  begin
    case (opc)
      6'b000000 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0100010000100;
      6'b100011 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0000100101100;
      6'b101011 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0000100010000;
      6'b000100 : begin {jalsel,ALUsrc,ALUop,writemem,readmem,regwrite,jumpsel}=7'b00010000;   branch=zero; end
      6'b000101 : begin {jalsel,ALUsrc,ALUop,writemem,readmem,regwrite,jumpsel}=7'b00010000;   branch=~zero; end
      6'b000010 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0000000000001;
      6'b000011 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b1010000000101;
      6'b001000 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0000100000100;
      6'b001010 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0000111000100;
      6'b001111 : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0001000000100;
    default : {jalsel,regdst,Pctoreg,uppersel,ALUsrc,ALUop,Memtoreg,writemem,readmem,regwrite,branch,jumpsel}=12'b0100010000100;
  endcase  
  end
endmodule 