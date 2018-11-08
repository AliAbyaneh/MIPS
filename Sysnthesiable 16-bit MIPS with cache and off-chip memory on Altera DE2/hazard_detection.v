// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module hazard_detection(rs1, rs2, rd_ex, rd_mem, rd_wb, stall, forward_en, opc_ex,
                        forward_A, forward_B, opc_id, opc_mem, opc_wb);
  input [2:0] rs1, rs2, rd_ex, rd_mem, rd_wb;
  input forward_en;
  input [3:0] opc_ex, opc_id, opc_mem, opc_wb;
  output reg stall;
  output reg [1:0] forward_A, forward_B;
  wire hazard_ex1, hazard_ex2 , hazard_mem1, hazard_mem2, hazard_wb1, hazard_wb2, hazard;
  wire hazard_ex, hazard_mem, hazard_wb;
  assign hazard_ex1 = (rd_ex == rs1 && rd_ex != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_ex2 = (rd_ex == rs2 && rd_ex != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_mem1 = (rd_mem == rs1 && rd_mem != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_mem2 = (rd_mem == rs2 && rd_mem != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_wb1 = (rd_wb == rs1 && rd_wb != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_wb2 = (rd_wb == rs2 && rd_wb != 3'b0) ? 1'b1 : 1'b0;
  assign hazard_ex = hazard_ex1 | hazard_ex2;
  assign hazard_mem = hazard_mem1 | hazard_mem2;
  assign hazard_wb = hazard_wb1 | hazard_wb2;
  assign hazard = hazard_ex | hazard_mem | hazard_wb;
  //assign stall = hazard;
  /*assign stall = (
                  (rd_ex == rs1 && rd_ex != 3'b0) ||
                  (rd_ex == rs2 && rd_ex != 3'b0) ||
                  (rd_mem == rs1 && rd_mem != 3'b0) ||
                  (rd_mem == rs2 && rd_mem != 3'b0) ||
                  (rd_wb == rs1 && rd_wb != 3'b0) ||
                  (rd_wb == rs2 && rd_wb != 3'b0)
                  ) ? 1'b1 : 1'b0;*/


  always @(rs1, rs2, rd_ex, rd_mem, rd_wb, forward_en, opc_ex)begin
    stall = 1'b0;
    forward_A = 2'b00;
    forward_B = 2'b00;
    //if(forward_en)
    //begin
      if(hazard_wb && opc_wb != 4'b1011 && opc_wb != 4'b0000)
      begin
        if(hazard_wb1)
          forward_A = 2'b11;
        if(hazard_wb2 && opc_id != 4'b1001)
          forward_B = 2'b11;
      end
      if(hazard_mem && opc_mem != 4'b1011 && opc_mem != 4'b0000)
      begin
        if(hazard_mem1)
          forward_A = 2'b10;
        if(hazard_mem2 && opc_id != 4'b1001)
          forward_B = 2'b10;
      end
      if(opc_ex == 4'b1010 && hazard_ex == 1'b1)
      begin      //LD instruction followed by any other instruction should wait until
                //LD is at mem stage
        stall = 1'b1;
      end
      else if(hazard_ex == 1'b1 && opc_ex != 4'b1011 && opc_ex != 4'b0000)
      begin
        if(hazard_ex1 == 1'b1)
          forward_A = 2'b01;
        if(hazard_ex2 == 1'b1 && opc_id != 4'b1001)
          forward_B = 2'b01;
      end
    //end


    //stall = (|forward_A | |forward_B) & (~forward_en);
    if(forward_en == 1'b0)
    begin
      if(forward_A == 2'b00 &&  forward_B == 2'b00 && stall == 1'b0)
        stall = 1'b0;
      else
        stall = 1'b1;
    end
  end
endmodule
