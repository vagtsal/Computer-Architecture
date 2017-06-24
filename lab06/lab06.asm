
        .data        
number:	.word  	11880				# store in memory address 0        a random number
string:	.asciiz	"This is a Test" 		# store in memory addresses 4-16   a string 
array:  .word -2147483648, -1, 0, 2147483647 	# store in memory addresses 20-32  an array of numbers (lowest signed 32-bit int, -1, 0, highest 32-bit signed int)
       
        .globl main

        .text
main:   
	# testing arithmetic instructions
	addi $t0, $zero, 32767		# store highest 16-bit signed int in reg  $t0  using addi
	addi $t1, $zero, -32768		# store lowest  16-bit signed int in reg  $t0  using addi
	
	add $t2, $t0, $t1		# store  addition  	  of previous numbers in reg  $t2 (=-1)    using  add
	sub $t3, $t0, $t1		# store  subtraction 	  of previous numbers in reg  $t3 (=65535) using  sub
	and $t4, $t0, $t1		# store  "and" operation  of previous numbers in reg  $t4 (=0)     using  and
	or  $t5, $t0, $t1		# store  "or"  operation  of previous numbers in reg  $t5 (=-1)    using  or    (changes later in beq testing, =0, and finally, =-2)
	
	slt $t6, $t0, $t1		# set reg  $t6=0  when ($t0 < $t1) == false using slt
	slt $t7, $t1, $t0		# set reg  $t7=1  when ($t1 < $t0) == true  using slt
	
	lui $t8, 32767			# store                 32767<<16              in reg  $t8 		    using lui
	ori $t8, $t8, 32767 		# store  "or" operation  between $t8 and 32767 in reg  $t8 (=2147450879)    using ori
	
	
	#testing beq instruction
jump1:	
	beq $t4, $t5, jump4		# First pass: 0=-1, false, downward branch not taken.	 Second pass: 0=0, exit beq testing
	beq $t2, $t5, jump3 		# -1=-1, true, downward branch taken
	
jump2:	
	addi $t5, $zero, -2		# these 2 instructions will not execute in the testing beq but they will execute in the end (when testing j instruction)
					# using $t5 as a flag, if finally $t5=-2, j instruction worked.
	j exit				# jump downwards 
	
jump3:	
	beq  $t4, $t5, jump2		# 0=-1, false, upward branch not taken
	addi $t5, $t5, 1 		# $t5++ (=0)
	beq  $t4, $t5, jump1		# 0=0, true, upward branch taken

jump4: 
	
	#testing lw,sw instructions (values in multiple registers to test them)
	la $a1, number			# store "number" address in reg $a1 (=0), "la" pseudo-instruction, "lui","ori" are executed
	la $a2, string			# store "string" address in reg $a2 (=4)  "la" pseudo-instruction, "lui","ori" are executed
	la $a3, array			# store "array"  address in reg $a3 (=20) "la" pseudo-instruction, "lui","ori" are executed
	
	lw $s0, 0($a1)			# load number and copy it in address 32
	sw $s0, 128($a1)		# (testing positive offset)
	
	lw $s1, 0($a2)			# load "string" and copy it in the addresses 60-63 (highests)
	sw $s1, 236($a2)		# (testing memory capacity)
	lw $s1, 4($a2)
	sw $s1, 240($a2)
	lw $s2, 8($a2)
	sw $s2, 244($a2)
	lw $s3, 12($a2)
	sw $s3, 248($a2)
	
	lw $s4, 0($a3)			# load "array" and copy it in "string" address
	sw $s4, -16($a3)		# (testing negative offset)
	lw $s5, 4($a3)
	sw $s5, -12($a3)
	lw $s6, 8($a3)
	sw $s6, -8($a3)
	lw $s7, 12($a3)
	sw $s7, -4($a3)
	
	
	# testing addiu instruction
	addiu $t9, $s7, 1		# add 1 to highest signed 32-bit integer, $t9 = -2147483648
	#addi $t9, $s7, 1		# same as previous instruction addiu in modelsim simulation, in mars it throws an overflow exception (un-comment instruction to check it)
	lw $v0, 0($s1)

	# testing j instruction
	j jump2				# jump upwards

exit:

