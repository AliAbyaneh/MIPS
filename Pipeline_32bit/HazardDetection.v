module HazardDetection(IFID_rt, IFID_rs, IFID_aluop, IDEX_rt, IDEX_rd, IDEX_regwrite, IDEX_memread, EXMEM_rt, EXMEM_memread, PCwrite, IFIDwrite, hold);
  input [4:0] IFID_rt, IFID_rs;
  input [1:0] IFID_aluop;
  input [4:0] IDEX_rt, IDEX_rd;
  input IDEX_regwrite, IDEX_memread;
  input [4:0] EXMEM_rt;
  input EXMEM_memread;
  output reg PCwrite, IFIDwrite, hold;
  always @(*)begin
    PCwrite = 1'b1; IFIDwrite = 1'b1; hold = 1'b0;
    //handles stall needed for LW followed by Rtype or Branch
    //example : lw r1,0(r10) beq r1,r2
    //example : lw r1,0(r10) add r2, r1, r3
    if((IDEX_rt == IFID_rt || IDEX_rt == IFID_rs) && IDEX_memread && IDEX_rt != 0)begin
      PCwrite = 1'b0; IFIDwrite = 1'b0; hold = 1'b1;
    end
    //handle stall needed after an arithmatic operatin followed by branch
    //example add r1, r2, r3 beq r1, r5
    if((IDEX_rd == IFID_rs || IDEX_rd == IFID_rt) && IDEX_regwrite && IFID_aluop == 2'b01 && IDEX_rd != 0)begin
      PCwrite = 1'b0; IFIDwrite = 1'b0; hold = 1'b1;
    end
    //hanldes the second stall needed fo LW followed by Branch
    if((EXMEM_rt == IFID_rs || EXMEM_rt == IFID_rt) && EXMEM_memread && IFID_aluop == 2'b01 && EXMEM_rt != 0)begin
      PCwrite = 1'b0; IFIDwrite = 1'b0; hold = 1'b1;
    end
  end
endmodule