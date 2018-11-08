module ALU (op1, op2, ALUcontrol, res, zero, HI, LO);

  parameter AND = 3'b000, OR = 3'b001, ADD = 3'b010, SUB = 3'b110, SLT = 3'b111, MUL = 3'b011, DIV = 3'b100;
  input [31:0] op1, op2;
  input [2:0] ALUcontrol;
  output reg zero;
  output reg [31:0] res, HI, LO;
  always@(op1, op2, ALUcontrol)
  begin:ALUEVAL
    
    {HI,LO} = 64'b0;
     case(ALUcontrol)
      AND: res = op1 & op2;
      OR:  res = op1 | op2;
      ADD:  res = op1 + op2;
      SUB:  res = op1 - op2;
      SLT:  res = ($signed(op1) <= $signed(op2)) ? 32'h00000001: 32'h0;
      MUL:  {HI,LO} = op1 * op2;
      DIV:begin  res[31:16] = op1 / op2; res[15:0] = op1 % op2; end
      default: res = 32'b0;
    endcase 
    zero = (res == 32'b0)? 1'b1: 1'b0;
  end

 
endmodule
