// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module testbench ();
  reg rst = 0,clk=0;
  MIPS ut1 (clk,rst);
  initial begin
    #1  rst=1;
    #10 rst = 0;
    #1800 $stop;
  end
  always
    repeat (400) #10 clk=~clk;
endmodule
