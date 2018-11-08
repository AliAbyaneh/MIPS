module sign_extend(in, out);
  input [15:0] in;
  output [31:0] out;
  wire [15:0] sgn;
  genvar i;
  for(i = 0; i < 16; i = i + 1)
    assign sgn[i] = in[15];
  assign out = {sgn, in};
endmodule
