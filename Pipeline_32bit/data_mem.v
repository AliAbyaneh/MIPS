module data_mem(address, writeData, clk, rst, writeMem, readMem, readData);
  input [31:0] address, writeData;
  input clk, rst, writeMem, readMem;
  output [31:0] readData;
  wire [31:0] memWord;
  reg [7:0] dataMem [0:255];
  
  assign memWord = {dataMem[address],dataMem[address + 1],dataMem[address + 2],dataMem[address + 3]};
  
  assign readData = (readMem) ? memWord : 32'b0; 
  
  integer i;
  always @(posedge clk)
  begin
    if(rst)
      for(i = 0; i < 256; i = i + 1)
        dataMem[i] = 8'b0;
    else if(writeMem)
    begin
      {dataMem[address],dataMem[address + 1],dataMem[address + 2],dataMem[address + 3]} = writeData;  
   
    end
  end
  initial $readmemb("data_mem.bin", dataMem);
endmodule