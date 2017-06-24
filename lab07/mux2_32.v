module mux2_32(
input  [31:0] d0, d1, 
input         s, 
output [31:0] y);

  assign #10 y = s ? d1 : d0; 
endmodule
