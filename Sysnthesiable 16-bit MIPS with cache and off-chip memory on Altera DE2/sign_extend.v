// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module sign_extend(in, out);
  input [5:0] in;
  output [15:0] out;
  wire [9:0] sgn;
  assign out = (in[5] == 1'b0) ? {10'b0, in} : {10'b1111111111, in};
endmodule
