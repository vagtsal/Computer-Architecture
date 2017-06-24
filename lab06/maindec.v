module maindec(input  [5:0] op,
               output       memtoreg, memwrite,
               output       branch,
               output [1:0] alusrc,
               output       regdst, regwrite,
               output       jump,
               output [1:0] aluop);

  reg [9:0] controls;

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop} = controls;

  // Implemented instructions:
  // lw, sw
  // beq, j
  // addi, addiu,
  // ori,
  // lui,
  // add, sub, and, or, slt, 
  always @(*)
    case(op)
      6'b000000: controls = 10'b11_00_0000_10; //Rtype
      6'b100011: controls = 10'b10_01_0010_00; //LW
      6'b101011: controls = 10'b00_01_0100_00; //SW
      6'b000100: controls = 10'b00_00_1000_01; //BEQ
      6'b001000: controls = 10'b10_01_0000_00; //ADDI
      6'b001001: controls = 10'b10_01_0000_00; //ADDIU same as addi - ignore overflows
      6'b000010: controls = 10'b00_00_0001_00; //J
      6'b001111: controls = 10'b10_10_0000_00; //LUI
      6'b001101: controls = 10'b10_01_0000_11; //ORI
      default:   controls = 10'bxx_xx_xxxxxx; //???
    endcase
endmodule
