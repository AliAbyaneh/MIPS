module forward_unit(rd_mem,rd_wb,rs_ex,rt_ex,regwrite_ex,regwrite_wb,rt_wb, readmem_wb,forwarda,forwardb);
  input [4:0] rd_mem,rd_wb,rs_ex,rt_ex, rt_wb;
  input regwrite_ex,regwrite_wb, readmem_wb;
  output reg [1:0] forwarda,forwardb;
  always @(rd_mem,rd_wb,rs_ex,rt_ex,regwrite_ex,regwrite_wb)
  begin 
    {forwarda,forwardb}=4'b0000;
    if(rd_mem==rs_ex && regwrite_ex==1 && rd_mem!=0)
      forwarda=2'b10;
    if(rd_mem==rt_ex && regwrite_ex==1 && rd_mem!=0)
      forwardb=2'b10; 
    if(rd_wb==rs_ex && regwrite_wb==1 && rd_wb!=0 && !(rd_mem==rs_ex && regwrite_ex==1 && rd_mem!=0))
      forwarda=2'b01;
    else if(rt_wb == rs_ex && readmem_wb == 1 && rt_wb != 0 && !(rd_mem==rs_ex && regwrite_ex==1 && rd_mem!=0))
      forwarda = 2'b01;
    if(rd_wb==rt_ex && regwrite_wb==1 && rd_wb!=0 && !(rd_mem==rt_ex && regwrite_ex==1 && rd_mem!=0))
      forwardb=2'b01; 
   else if(rt_wb == rt_ex && readmem_wb == 1 && rt_wb != 0  && !(rd_mem==rs_ex && regwrite_ex==1 && rd_mem!=0))
      forwardb = 2'b01;
   end  
  
  endmodule

  
