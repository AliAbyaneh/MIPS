// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module mux4to1 (a, b, c, d, sel, w);
  input [15:0] a, b, c, d;
  input [1:0] sel;
  output [15:0] w;
  assign w =  (sel == 2'b00) ? a :
              (sel == 2'b01) ? b :
              (sel == 2'b10) ? c : d;
endmodule
