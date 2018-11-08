// Authors : Ali Abyaneh, Mahyar Emami
// Fall 2016, Computer Architecture
// Arithmatic and Logic Unit Controller Verilog Implementation 

module ALUcontrol(ALUop, func, ALUoperation, hiloread, mult, jrsel, mf);
  input [1:0] ALUop;
  input [5:0] func;
  output reg hiloread,mult, jrsel, mf;
  output reg [2:0] ALUoperation;
  
  
  always @(ALUop, func)
  begin
    case (ALUop)
      2'b00: {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100000;
      2'b01: {ALUoperation,hiloread,mult,jrsel, mf} = 7'b1100000;
      2'b10: begin
            case(func)
              6'b100000:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100000;
              6'b100010:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b1100000;
              6'b100100:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0000000;
              6'b100101:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0010000;
              6'b101010:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b1110000;
              6'b011000:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0110100;
              6'b010000:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0101001;  //mfhi
              6'b001000:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100010;  //mul
              6'b010010:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100001;  //mflo
              default :   {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100000;
            endcase
          end
        2'b11:  {ALUoperation,hiloread,mult,jrsel, mf} = 7'b1110000;
      default : {ALUoperation,hiloread,mult,jrsel, mf} = 7'b0100000;  
    endcase
  
  
  end
  
endmodule
