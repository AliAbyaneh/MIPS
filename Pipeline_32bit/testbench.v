module testbench ();
  reg rst = 1,clk=0;
  integer clockcount = 0;
  MIPS ut1 (clk,rst);
  initial begin
    #1  rst=1;
    #10 rst = 0;
    #40000 $stop;
  end
  always
    repeat (4000) #10 clk=~clk;
  always
    repeat (2000) #20 clockcount = clockcount + 1;
endmodule
