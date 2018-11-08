module comp (a,b,w);
  input [31:0] a,b;
  output w;
  assign w=(a==b) ? 1 :0;
endmodule

