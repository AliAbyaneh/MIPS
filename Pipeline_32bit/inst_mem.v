module inst_mem(instAdr, inst);
  input [31:0] instAdr;
  output [31:0] inst;
  reg [7:0] instMem [0:255];
  assign inst = {instMem[instAdr], instMem[instAdr + 1], instMem[instAdr + 2], instMem[instAdr + 3]};
  initial $readmemb("bubble_sort.bin", instMem);
endmodule