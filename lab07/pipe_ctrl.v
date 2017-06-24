module pipe_ctrl(
    input      [4:0] rs,
    input      [4:0] rt,
    input            isStore,
    input            isNop, // nop is sll r0, r0, 0
    input            readsRs,
    input            readsRt,
    input            branch,
    input            jump,
    input            brTaken,
    //  --- from EX ---
    input      [4:0] ex_rd,
    input            ex_regWrite,
    input            ex_isLoad,
    //  --- from MEM ---
    input      [4:0] mem_rd,
    input            mem_regWrite,
    // Outputs:
    output           flush,
    output           flowChange,
    output reg       stall,
    output reg [1:0] id_forwardA,
    output reg [1:0] id_forwardB,
    output reg       id_ldstBypass
);

assign flush = (branch && brTaken && ~stall) | jump;

assign flowChange = flush;

// Forwarding control for operand A (rs)
// 2'b00 - reg file
// 2'b10 - from mem to ex
// 2'b01 - from wb  to ex
// Note: forwarding will happen at next cycle
always @(*) begin
	 if (ex_regWrite && (ex_rd != 0) && (ex_rd == rs)) 				// if the previous instruction changes a register that the current instruction uses as an input...
			id_forwardA = 2'b10;													// 	select ALU output of the previous intruction.
	 else if (mem_regWrite && (mem_rd != 0) && (mem_rd == rs))		// if the second previous instruction changes a register that the current instruction uses it as an input...
			id_forwardA = 2'b01;													// 	select write back value of the second previous instruction.
	 else 		 																	// if no previous instruction changes a register that the current instruction uses as an input...
		   id_forwardA = 2'b00;													// 	select register from reg file.
    
end

//  This is only needed for R-types or SW.
//  However, as the immediate mux is after the bypass mux,
//   we don't care about forwardB when rt is not used as a source (e.g. addi, lw)
always @(*) begin
	 if (ex_regWrite && (ex_rd != 0) && (ex_rd == rt))					// if the previous instruction changes a register that the current instruction uses as an input...
			id_forwardB = 2'b10;													// 	select ALU output of the previous intruction.
	 else if (mem_regWrite && (mem_rd != 0) && (mem_rd == rt))		// if the second previous instruction changes a register that the current instruction uses as an input...
			id_forwardB = 2'b01;													// 	select write back value of the second previous instruction.
	 else																				// if no previous instruction changes a register that the current instruction uses as an input...
			id_forwardB = 2'b00;  												// 	select register from reg file.  
end

// Forward just loaded value to subsequent store
// E.g.
// lw $t0, 0($s0)
// sw $t0, 0($s1)
always @(*) begin
	 if (isStore && ex_isLoad  && (ex_rd != 0) && (ex_rd == rt))	// if previous instruction is lw, current is sw and they point to the same (load to/store from) register...
			id_ldstBypass = 1'b1; 												// 	enable lw/sw bypass.											
	 else
			id_ldstBypass = 1'b0;
end

always @(*) begin
	 if (ex_isLoad && (ex_rd != 0) && ((ex_rd == rs)  || (ex_rd == rt)))				// if previous instruction is lw and the current one uses the load register of the previous instruction...
			stall = 1'b1; 																				//		enable stall.
	 else if (branch && (((ex_rd != 0) && ((ex_rd == rs) || (ex_rd == rt))) || ((mem_rd != 0) && ((mem_rd == rs) || (mem_rd == rt))))) 	// if a branch instruction does not have an updated register value...
			stall = 1'b1;																																						//		enable stall.
	 else 
			stall = 1'b0;
end

initial begin
   stall = 1'b0;
   id_forwardA = 2'b00;
   id_forwardB = 2'b00;
   id_ldstBypass = 1'b0;
end

endmodule
