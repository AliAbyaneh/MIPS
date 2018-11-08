// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture

module JRcontrol(opc, func, jrsel);
  input [5:0] opc, func;
  output jrsel;
  assign jrsel = (opc == 6'b0 && func == 6'b001000) ? 1'b1 : 1'b0;
endmodule
