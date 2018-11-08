module StallHandler(opc, func, branch, stall);
  input [5:0] opc, func;
  input branch;
  output stall;
  assign stall = ( (opc == 6'b000100 && branch ) || (opc == 6'b000101 && branch) || opc == 6'b000010 || opc == 6'b000011 || (opc == 6'b0 && func == 6'b001000)) ? 1'b1 : 1'b0;
endmodule