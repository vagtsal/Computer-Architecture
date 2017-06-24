    .text
main:
    teqi   $zero, 0     # immediately trap because $zero contains 0
loop:
    addiu  $t1, $t1, 1
    j      loop

 # Exception handler
    .ktext 0x80000180	# Forces interrupt routine below to be
                        # located at address 0x80000180.
interp:
    # Critical code. Turn off all interupts
    #   $k0, $k1 are OK to use. User code should not use them.
    mfc0  $k0, $12          # get status register
    andi  $k0, $k0, 0xfffe  # clear int enable flag
    mtc0  $k0, $12          # Turn interrupts off.	

    # interrupt handler - all registers are precious
    # Save registers to stack.  Remember, this is an interrupt routine
    # so it has to save anything it touches, including $t registers.
    addiu $sp,$sp,-32	# Save registers. 
    sw    $at,28($sp)	#  even $at - assembler temporary.
    sw    $ra,24($sp)
    sw    $a0,20($sp)
    sw    $v0,16($sp)
    sw    $t3,12($sp)
    sw    $t2,8($sp)
    sw    $t1,4($sp)
    sw    $t0,0($sp)	

    mfc0  $t0, $13            # get Cause register
    srl   $t1, $t0,   2       # move exception code to bit 0
    andi  $t1, $t1,   0x1f    #   and extract it
    beq   $t1, $zero, hw_int  # Hardware interrupt exception
    li    $t2, 0xd            # 0xd = 13 = Trap exception
    bne   $t1, $t2,   excDone # We can't handle this exception!
    # ------ traps -----------------
    # I assume the trap is only used to enable interrupts by the MMIO
    jal   enable_term_int
    #  traps must resume execution from the instruction following the trap:
    #   increment epc (register 14 of coprocessor 0) by 4
    mfc0  $t0, $14
    addiu $t0, $t0, 4
    mtc0  $t0, $14
    j     excDone
    # ------------------------------
hw_int:  # Hardware interrupt
    # Check what caused the interrupt: $t0 holds original Cause register value
    andi  $t1, $t0, 0x100   # check bit 8 - MMIO receiver interrupt
    beq   $t1, $zero, checkTransmit 
   # Interrupt is for receiver - got key-press
    jal   getChar
    j     excDone
checkTransmit:
    andi  $t1, $t0, 0x200   # check bit 9 - MMIO transmitter interrupt
    beq   $t1, $zero, excDone # Unknown hardware exception. Leave.
    # Interrupt is for transmitter - ready to send next char
    jal   putChar
excDone:
    ## restore registers
    lw    $t0,0($sp)
    lw    $t1,4($sp) 
    lw    $t2,8($sp) 
    lw    $t3,12($sp) 
    lw    $v0,16($sp) 
    lw    $a0,20($sp)
    lw    $ra,24($sp)
    lw    $at,28($sp) 
    addiu $sp,$sp,32
    ## Clear Cause register
    mtc0  $zero, $13
    # Turn interrupts back on
    mfc0  $k0, $12       # get status
    andi  $k0, $k0, 0xfffd # Clear bit 1 (exception)
    ori   $k0, $k0, 0x01 # set interrupt enable flag
    mtc0  $k0, $12       # 
    eret   # rtn from interrupt (EPC - $14 is the return address)

    # -------------------------------------------------------------------------
getChar:
    # No need to check if ready.
    lui     $t0, 0xffff    # get address of MMIO base address
    lw      $v0, 4($t0)	   # read rcv data - ascii code
    # ---- copy to circular buffer
    la      $t0, rcvInput
    lw      $t1, 0($t0)    # Get circular buffer input index
    la      $t2, rcvBuf     # base of circular buffer
    add     $t2, $t1, $t2  # Address in circular buffer for next input
    sb      $v0, 0($t2)        # store next character.
                           # Update input index.
    addiu   $t1, $t1, 1    
    andi    $t1, $t1, 15       # wrap index from 16 to 0
    sw      $t1, 0($t0)    # Update value of buffer input index

    la      $t0, rcvOutput
    lw      $t2, 0($t0)    # Get circular buffer output index
    # if rcvInput == rcvOutput, we've overrun the buffer
    #   and have overwritten the oldest key, must move the rcvOutput
    #   pointer forward.
    bne     $t1, $t2, skip
    addiu   $t2, $t2, 1    # Move output index forward
    andi    $t2, $t2, 15       # wrap index from 16 to 0
    sw      $t2, 0($t0)      # update output index
skip:
    # --- end of circular buffer code

    # if tx is ready, jump to putChar.
    #  Note that we **do not** jal to putChar!
    #  The return instruction of putChar (jr $ra) will return back to getChar's caller...
    #  This is nasty coding, but we are OS and OS is nasty!
    lui     $t1, 0xffff
    lw      $t1, 0x8($t1)
    andi    $t1, $t1, 0x1
    bne     $t1, $zero, putChar
    jr      $ra


    # -------------------------------------------------------------------------
putChar:

    la      $t0, rcvInput	# Get input index
    lw      $t1, 0($t0)
    
    la      $t0, rcvOutput	# Get output index
    lw      $t2, 0($t0)   
    
    beq     $t1, $t2, return	# If input index equals output index (empty buffer), return
    
    la      $t3, rcvBuf    	# Get base of circular buffer
    add     $t3, $t3, $t2  	# Address in circular buffer for next output
    
    lb      $t4, 0($t3)         # load next character.
    
    # Update output index.
    addiu   $t2, $t2, 1    
    andi    $t2, $t2, 15        # wrap index from 16 to 0
    sw      $t2, 0($t0)    	# Update value of buffer output index
    
    lui     $t0, 0xffff    	# get address of MMIO base address
    sw      $t4, 0xc($t0) 	# write character

return:
    jr      $ra


    # -------------------------------------------------------------------------
enable_term_int:	
    # Enable interrupts by terminal receiver
    lui     $t0,  0xffff
    lw      $t1,  0($t0)      # read rcv ctrl
    ori     $t1,  $t1, 0x02   # set the receiver interrupt enable
    sw      $t1,  0($t0)      # update rcv ctrl
    # Enable interrupts by terminal transmitter
    lw      $t1,  0x8($t0)    # read tx ctrl
    # Also set the enable to 1, so as to trigger ints from now on
    #     this is supposed to be read only, but it is not!
    ori     $t1,  $t1, 0x03	  # set the output interupt enable
    sw      $t1,  0x8($t0)    # update tx ctrl
    # Initialize circular buffer indices:
    la      $t1,   rcvInput
    sw      $zero, 0($t1)
    la      $t1,   rcvOutput
    sw      $zero, 0($t1)
    jr      $ra

    .kdata
rcvInput:     # Index at which to insert chars
    .word 0
rcvOutput:    # Index at which to remove chars
    .word 0
rcvBuf:       # Storage space.
    .space 16
