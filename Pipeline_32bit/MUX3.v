module MUX3 (in0,in1,in2,sel,w);
  input [1:0]sel;
  input [31:0] in0,in1,in2;
  output [31:0] w;
  assign w=(sel==2'b00) ? in0 :
           (sel==2'b01) ? in1 :
           (sel==2'b10) ? in2 : 32'b0;
           
 endmodule
          
