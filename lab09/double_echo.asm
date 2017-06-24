    .text
main:
    # write your code here
    jal getc
    or $a0, $v0, $zero
    jal putc
    jal putc
    
	#  Do not remove the j main instruction
    j   main

getc:		
#   v0 = received byte		
    lui  $t0, 0xffff		
gcloop:
    lw   $t1, 0($t0)        # read rcv ctrl
    andi $t1, $t1,   0x01   # extract ready bit
    beq  $t1, $zero, gcloop # keep polling till ready
    lw   $v0, 4($t0)        # read data and rtn
    jr   $ra		
	
putc:		
#   a0 = byte to trransmit
    lui  $t0, 0xffff			
pcloop:
    lw   $t1, 8($t0)        # read tx ctrl
    andi $t1, $t1,   0x01   # extract ready bit 
    beq  $t1, $zero, pcloop # wait till ready
    sw   $a0, 0xc($t0)      # write data
    jr   $ra

    .data

