# Calculate sums of positive odd and negative even values in an array
#   in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

        .globl main # declare the label main as global. 
        
        .text 
     
main:
        la         $a0, length       # get address of length to $a0
        lw         $a0, 0($a0)       # get the length in to $a0

        la         $a1, input        # get address of array to $a1

        addiu      $s0, $zero, 0     # sum of positive odd values starts as 0
        addiu      $s1, $zero, 0     # sum of negative even values starts as 0


        ######################## ADDED CODE ############################

	# while ($a0 != 0) #
loop:					
	beq 	$a0, $zero, exit	# if $a0 is zero goto "exit" (while ($a0 != 0))
	
	lw	$t0, 0($a1)		# load nth value of the array to $t0
	
		# if ($t0 > 0) #
	slt	$t1, $t0, $zero		# if $t0 is lower than zero ($t0 < 0)...						
	bne	$t1, $zero, else	# ...goto "else"
	
			# if ($t0 is odd) #
	andi 	$t1, $t0, 1		# AND operation between $t0 and 1
	beq	$t1, $zero, if_out	# if $t1 is 0 ($t0 is even), goto "if_out"
	
	add	$s0, $s0, $t0		# else add $t0 to $s0
	
	j	if_out			# exit if

		# else ($t0 < 0) #
else:		
			# if ($t0 is even) #
	andi	$t1, $t0, 1		# AND operation between $t0 and 1
	bne	$t1, $zero, if_out	# if $t1 is 1 ($t0 is odd), goto "if_out"
	
	add	$s1, $s1, $t0		# else add #t0 to $s1

if_out:	
	addi	$a1, $a1, 4		# increase array pointer #a1 by 4
	addi 	$a0, $a0, -1		# decrease the counter of the remaining array elements
	
	j 	loop			# goto the start of the while loop
	        	                        
        ########################################################################
        
exit: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.
        
        ###############################################################################
        # Data input.
        ###############################################################################
        .data
length: .word 5
input: .word -1, 2, -7, 40, -33
