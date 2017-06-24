# Very simple interrupt driven I/O
    .text
main: # user program
    teqi  $zero, 0  # trap: enable MMIO interrupts for receiver (keyboard)
loop:            # Infinite loop
    addiu $t1, $t1, 1
    j     loop

# -------------------------------------
# System interrupt handler 
# -------------------------------------
    .ktext 0x80000180	# Forces interrupt routine below to be
				# located at address 0x80000180.
interp:
    # Critical code. Turn off all interupts
    #   $k0, $k1 are OK to use. User code should not use them.
    mfc0  $k0, $12	        # get status register
    andi  $k0, $k0, 0xfffe	# clear int enable flag
    mtc0  $k0, $12	        # Turn interrupts off.	

    # interrupt handler - all registers are precious
    # Save registers.  Remember, this is an interrupt routine
    # so it has to save anything it touches, including $t registers.
    # Must also save any $t registers used by subroutines called from here
    addiu $sp, $sp, -32 # Save registers. 
    sw    $at, 28($sp)  # so we can use it.
    sw    $ra, 24($sp)
    sw    $a0, 20($sp)
    sw    $v0, 16($sp)
    sw    $t3, 12($sp)
    sw    $t2, 8($sp)
    sw    $t1, 4($sp)
    sw    $t0, 0($sp)	

    mfc0  $t0, $13        # get Cause register
    srl   $t1, $t0, 2     # move exception code to bit 0
    andi  $t1, $t1, 0x1f  #   and extract it
    beq   $t1, $zero, hw_int  # Hardware interrupt exception
    li    $t2, 0xd        # 0xd = 13 = Trap exception
    bne   $t1, $t2, excDone  # We can't handle this exception, ignore.
    # ---- This is a trap -----
    # I assume the trap is only used to enable interrupts by the MMIO
    jal   enable_term_int
    #  traps must resume execution from the instruction following the trap:
    #  (but Interrupts have to re-play the interrupted instruction)
    #   increment epc (register 14 of coprocessor 0) by 4
    mfc0  $t0, $14
    addiu $t0, $t0, 4
    mtc0  $t0, $14
    j     excDone
    # ---- This is a hardware (external) interrupt -----
hw_int:
    lui   $t0, 0xffff         # get address of control regs
    lw    $t1, 0($t0)	      # read rcv ctrl
    andi  $t1, $t1,   0x01    # extract ready bit
    beq   $t1, $zero, excDone # no key pressed, done
    lw    $a0, 4($t0)         # read key
    lw    $t1, 8($t0)         # read tx ctrl
    andi  $t1, $t1,   0x01    # extract tx ready bit 
    beq   $t1, $zero, excDone # tx busy, discard
    sw    $a0, 0xc($t0)	      # write key
    # -------------------------------------
excDone:
    ## restore registers
    lw    $t0, 0($sp)
    lw    $t1, 4($sp) 
    lw    $t2, 8($sp) 
    lw    $t3, 12($sp) 
    lw    $v0, 16($sp) 
    lw    $a0, 20($sp)
    lw    $ra, 24($sp)
    lw    $at, 28($sp) 
    addiu $sp, $sp, 32
    ## Clear Cause register
    mtc0  $zero, $13
    # Turn interrupts back on
    mfc0  $k0, $12         # get status
    andi  $k0, $k0, 0xfffd # Clear bit 1 (exception)
    ori   $k0, $k0, 0x01   # set interrupt enable flag
    mtc0  $k0, $12
    eret  # rtn from int

# -------------------------------------
# enable_term_int - enables interrupts for MMIO receiver (keyboard)
# -------------------------------------
enable_term_int:	
    lui     $t0, 0xffff		
    lw      $t1, 0($t0)	     # read rcv ctrl
    ori     $t1, $t1, 0x0002 # set the input interupt enable
    sw      $t1, 0($t0)	     # update rcv ctrl
    jr      $ra

