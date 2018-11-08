module PC (clk,in,rst,En,w);
  input clk,rst,En;
  input [31:0] in;
  output reg [31:0] w;
  always @(posedge clk)begin if(rst)w =32'b0; else if(En)  w = in; end
endmodule
