module MUX5(in0, in1, se, out);
  input [4:0] in0, in1;
  input se;
  output [4:0] out;
  assign out = (se) ? in1: in0;
endmodule
