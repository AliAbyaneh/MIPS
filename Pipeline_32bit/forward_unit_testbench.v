module fu_testbench();
  reg [4:0] rd_mem,rd_wb,rs_ex,rt_ex;
  reg regwrite_ex,regwrite_wb;
  wire [1:0] forwarda,forwardb; 
 forward_unit ut1(rd_mem,rd_wb,rs_ex,rt_ex,regwrite_ex,regwrite_wb,forwarda,forwardb); 
 initial
 begin
   rd_mem=5'b00110;
   rd_wb=5'b01101;
   regwrite_ex=1;
   regwrite_wb=1;
   rs_ex=5'b00110;
   rt_ex=5'b01101;
   #300
   rs_ex=5'b10000;
   rt_ex=5'b00110;
   #300
   rd_mem=5'b00000;
   rt_ex=5'b00000;
   #300
   $stop;
 end
endmodule
