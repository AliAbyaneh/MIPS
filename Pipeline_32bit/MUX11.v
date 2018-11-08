module MUX11(in0, in1, se, out);
  input [11:0] in0, in1;
  input se;
  output [11:0] out;
  assign out = (se) ? in1: in0;
endmodule
