# This program accesses an array in ways that provide data about the parameters
# of the cache on the simulated computer.  Here is the pseudocode.

#    /* Repeat a given number of times. */
#    for (k = 0; k < repcount; k++) {
#      /* Step through the selected array segment with the given step size. */
#      limit = arraysize - stepsize + 1;
#      for (index = 0; index < limit; index = index + stepsize) {
#        /* Right-hand side accesses the cache. */
#        array[index/4] = array[index/4] + 1;
#      }
#    }

	.data
counter: 		# ADD THIS LABEL
	.word 0 	# AND THIS DIRECTIVE
array:
	.space	2048
	
	.text
main:

# Supply values for array size, step size, and repetition count.
# arraysize must be a positive power of 2, less than or equal the number of bytes
#   allocated for "array".
# stepsize must divide arraysize with a remainder of 0.
# repcount must be at least 1.
# summary of register use:
#  $s0 = array size
#  $s1 = stepsize
#  $s2 = stepsize in bytes
#  $s3 = number of times to repeat
#  $s5 = index in bytes
#  $s6 = &array[index/4]
	
    li     $s0, 32	# array size
    li     $s1, 1	# step size
    li     $s3, 1	# rep count
    
    la $t1, counter 	# ADD THIS INSTRUCTION

	sll    $s2, $s1, 2  # Convert step to bytes
	
outerloop:
    # loop initialization: $s5 contains index, $s6 contains &array[index]
    add	  $s5, $0, $0
    la	  $s6, array

innerloop:
    # array[index]++
    lw    $t0, 0($s6)
    addi  $t0, $t0, 1
    sw    $t0, 0($s6)
	
    # inner loop done?
    addu  $s5, $s5, $s1
    addu  $s6, $s6, $s2
    sw 	  $t0, 0($t1)		 # ADD THIS INSTRUCTION
    bne   $s5, $s0, innerloop
	
    addi  $s3, $s3,   -1
    bne   $s3, $zero, outerloop
		
    li    $v0, 10
    syscall
