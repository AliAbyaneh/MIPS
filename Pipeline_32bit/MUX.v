module MUX(in0, in1, se, out);
  input [31:0] in0, in1;
  input se;
  output [31:0] out;
  assign out = (se) ? in1: in0;
endmodule