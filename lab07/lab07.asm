
        .data
n1:
        .word  1
n15:
        .word  15
n_m5:
        .word  -5
       
        .globl main

        .text
main:   
        lui $t0, 0x1001  # Note I plant the address of n1 manually here
                         # It won't work if data labels are moved about.
                         # this is because there's a hazard between the
                         # lui, ori instructions that la gets translated to..
        #add $zero, $zero, $zero   # ---- avoid hazzard  -----
        #add $zero, $zero, $zero   # ---- avoid hazzard  -----
        lw  $t1, 0($t0)   # 1
        
        sw  $t1, 16($t0)	  								# added to check lw-sw case (id_ldstBypass)
        
        lw  $t2, 4($t0)   # 15 = 32'b000...0_1111
        lw  $t3, 8($t0)   # -5 = 32'b111...1_1011
        
        add $s0, $t2, $t3									# added to check stall when current instruction reads registers of previous lw instructions
        
        beq $t1, $zero, notTaken
        j   skip
notTaken:  # should never get here!
        sw  $t3, 0($t0)    # Detect it by storing -5 in n1
        add $t0, $t4, $t4  # should generate X's in simulation, breaks $t0
        j   end
taken:
        sw  $t0, 0($t0)    # stores address of n1 in n1
        j   end
skip:
	and $t4, $t1, $t3 #  t4 = 32'b000...0_0001 
        or  $t5, $t3, $t2 #  t5 = 32'b111...1_1111 = -1
        #add $zero, $zero, $zero  #  ------ avoid hazzard  -----
        #add $zero, $zero, $zero  #  ------ avoid hazzard  -----
        slt $t6, $t4, $t5 # Should be 0
        #add $zero, $zero, $zero  #  ------ avoid hazzard  -----
        #add $zero, $zero, $zero  #  ------ avoid hazzard  -----
        beq $t6, $zero, taken  # backwards branch works?
        j   notTaken
end:
        sub $t7, $t2, $t1 # Should be 14
