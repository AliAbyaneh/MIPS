// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture

module datapath (clk,rst,ex,m,wb,branch,jumpsel,opc, eq);
  
  input clk,rst,branch,jumpsel;
  input [2:0] ex;
  input [1:0] m;
  input [5:0] wb;
  output [5:0] opc;
  output eq;
  
  
  wire [31:0] w7,w1,w2,w3,w4,w5,w6,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25,w26;
  wire [31:0]ifid_pc4, ifid_inst,readdata1, readdata2, idex_pc4, idex_readdata1, idex_readdata2, idex_inst,reswb,resmem;
  wire [31:0] res, hi, lo, exmem_pc4,exmem_res, exmem_readdata2, exmem_inst, exmem_hilo,memdata,memwb_pc4, memwb_memdata, memwb_res, memwb_inst, memwb_hilo;
  wire  zero, hiloread, mult, jrsel, writemem, readmem,uppersel,pctoreg,mf,exmem_write,ifid_write;
  wire i0,flush,idex_write, memwb_write,regwritef,memwb_mult,memwb_jrsel;
  wire [2:0] idex_ex,i1,exmem_rct, memwb_rct;
  wire [5:0] idex_wb, exmem_wb,memwb_wb;
  wire [1:0] idex_m, exmem_m, forwarda, forwardaa, forwardb, forwardbb;
  reg [31:0] c4=32'd4;
  wire [4:0] i23, i25;
  wire [11:0] i11;
  wire idex_branch;
  /*changed*/
  wire [31:0] hilo;
  
  
  
  /**************INSTRUCTION FETCH*******************/
  /*changed*/
  PC pc (clk,w7,rst,pcwrite,w1);
  inst_mem instmem (w1, w3);
  adder A1 (c4, w1, w2);
  /*changed*/
  IFID ifid(w2, w3, ifid_write, stall & (~hold), clk, rst, ifid_pc4, ifid_inst);
  /*changed*/
  
  
  
  
  
  /****************INSTRUCTION DECODE*****************/
  adder A2 (ifid_pc4, w9, w4);
  sign_extend SE(ifid_inst[15:0], w8);
  shl2 sh(w8, w9);
  MUX M1(w2, w4, branch, w5);
  MUX M2(w5, {ifid_pc4[31:28],ifid_inst[25:0],2'b00}, jumpsel, w6);
  /*changed*/
  MUX M3 (w6, readdata1, i0, w7);
  /*changed*/
  register_file regfile(ifid_inst[25:21],ifid_inst[20:16], i25, reswb, regwritef, clk, rst,readdata1, readdata2);
  /*changed*/
  JRcontrol jrc(ifid_inst[31:26],ifid_inst[5:0], i0);
  /*changed*/
  comp cmp (w10,w11,eq);
  /*changed*/
  MUX3 f00 (readdata1,reswb,resmem,forwardaa,w10);
  MUX3 f01 (readdata2,reswb,resmem,forwardbb,w11);
  /*changed*/
  
  
  
  /*******************EXECUTE*********************/
  IDEXE idex(i11[10:8], i11[7:6], i11[5:0], ifid_pc4, readdata1, readdata2, ifid_inst, i11[11], 1'b1, 1'b0, clk, rst, idex_ex, idex_m, idex_wb, idex_pc4, idex_readdata1, idex_readdata2, idex_inst, idex_branch);
  MUX3 f10(idex_readdata1,reswb,resmem,forwarda,w16);
  MUX3 f11(w14,reswb,resmem,forwardb,w15);
  MUX  M4 (idex_readdata2, w13, idex_ex[0], w14);
  /*changed*/
  sign_extend se2(idex_inst[15:0], w13);
  /*changed*/
  ALU A3(w16, w15,i1, res, zero, hi, lo);  
  ALUcontrol A6(idex_ex[2:1], idex_inst[5:0], i1, hiloread, mult, jrsel, mf);
  hi_lo_reg A7 (hi,lo,clk,rst, mult, hiloread, hilo);

  
  
  
  /****************MEMORY ACCESS**************/
  EXMEM exmem(idex_m,idex_wb,idex_pc4, res, idex_readdata2, {mf,mult,jrsel}, idex_inst, hilo, 1'b1, 1'b0, clk, rst, exmem_m, exmem_wb, exmem_pc4,exmem_res, exmem_readdata2, exmem_rct, exmem_inst, exmem_hilo);
  data_mem datamem (exmem_res, exmem_readdata2, clk, 1'b0, exmem_m[1], exmem_m[0], memdata);
  //assign {readmem,writemem}=exmem_m;
  /*changed*/
  MUX M5(exmem_res, exmem_hilo, exmem_rct[2], w17);
  MUX M6(w17, exmem_pc4, exmem_wb[4], w18);
  MUX M7(w18, {exmem_inst[15:0],16'b0}, exmem_wb[3], resmem);
  /*changed*/
  
  
  
  /************WRITE BACK*********/
  MEMWB memwb(exmem_wb, exmem_pc4, memdata, exmem_res, exmem_rct, exmem_inst, exmem_hilo, 1'b1, 1'b0, clk, rst, memwb_wb,memwb_pc4, memwb_memdata, memwb_res, memwb_rct, memwb_inst, memwb_hilo);
  /*changed*/
  MUX M8(memwb_res,memwb_memdata,memwb_wb[5],w20);
  MUX M9(w20,memwb_hilo,memwb_rct[2],w21);
  MUX M10(w21,memwb_pc4,memwb_wb[4],w22);
  MUX M11(w22,{memwb_inst[15:0],16'b0},memwb_wb[3],reswb);
  /*changed*/
  reg [4:0] ra=5'd29;
  MUX5 M12(memwb_inst[20:16],ra,memwb_wb[1],i23);
  MUX5 M13(i23,memwb_inst[15:11],memwb_wb[0],i25);
  //assign {memtoreg,pctoreg,uppersel,regwrite,jalsel,regdst}=memwb_wb;
  assign regwritef=(memwb_wb[2] & (~memwb_rct[1]) & (~memwb_rct[0]));
  
  /***************PERIPHERALS**************/
  forward_unit forwardUnit1(exmem_inst[15:11],memwb_inst[15:11],idex_inst[25:21],idex_inst[20:16],exmem_wb[2],memwb_wb[2], memwb_inst[20:16], memwb_wb[5],forwarda,forwardb);
  forward_unit forwardUnit2(exmem_inst[15:11],memwb_inst[15:11],ifid_inst[25:21],ifid_inst[20:16],exmem_wb[2],memwb_wb[2],memwb_inst[20:16], memwb_wb[5],forwardaa,forwardbb);
  StallHandler STALL (idex_inst[31:26],idex_inst[5:0],idex_branch, stall);
  HazardDetection HAZARD(ifid_inst[20:16], ifid_inst[25:21], ex[2:1], idex_inst[20:16], idex_inst[15:11], idex_wb[2], idex_m[0],exmem_inst[20:16], exmem_m[0], pcwrite, ifid_write, hold);
  MUX11 H({branch,ex,m,wb},12'b0,hold,i11);
  

  assign opc=ifid_inst[31:26];
  
endmodule
