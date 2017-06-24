#  Tsalesis Evangelos
#   in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

        .globl main # declare the label main as global. 
        
        .text 
     
main:
        ########################## ADDED CODE ###########################
        
        la	$a0, cols
        lw	$s0, 0($a0)		# $s0 -> cols
        
        la	$a0, rows
        lw	$s1, 0($a0)		# $s1 -> rows
        
        la	$a0, picture		# $a0 -> picture
        
 
       ########## Calculate row clues list ########## 
        la	$a1, r_clues			# $a1 -> r_clues address
        
        add	$t3, $zero, $a0			# $t3 -> current picture row address
              
        add	$s3, $zero, $s0			# $s3 -> counter_col = cols
        addi	$s4, $zero, 0			# $s4 -> counter_row = 0
        
loop_row:	
	beq	$s4, $s1, exit_loop_row		# while (counter_row!=row) {
	
	lw	$s5, 0($t3)				# $s5 -> current picture row
	add	$t2, $a1, $zero				# $t2 -> clue_position = current row r_clues address
	
loop_col:	
	beq	$s3, $zero, exit_loop_col		# while (counter_col!=0) {
	
	addi	$t0, $s3, -1					# Calculating current bit...
	srlv 	$t0, $s5, $t0					# current_row >> (counter_col-1)
	andi	$t0, $t0, 1					# $t0 -> current_bit
	
	beq	$t0, $zero, else				# if (current_bit != 0) {
	
	addi	$t1, $t1, 1						# $t1 -> clue_counter++
	j	if_exit						# }

else:								# else {
	beq	$t1, $zero, if_exit					# if clue_counter == 0, goto if_exit
	
	sw	$t1, 0($t2)						# store clue_counter into r_clues[current_row][clue_position]
	addi	$t1, $zero, 0						# clue_counter = 0
	addi	$t2, $t2, 4						# clue_position++
 
if_exit:       							# }
        addi	$s3, $s3, -1					# counter_col--
        j	loop_col				# }

exit_loop_col:
	beq	$t1, $zero, next_line			# if cell in last column is filled, store the current clue_counter	
	sw	$t1, 0($t2)				# store clue_counter into r_clues[current_row][clue_position]
	
	addi	$t1, $zero, 0				# clue_counter = 0

next_line:       
        addi	$a1, $a1, 64				# r_clues_address << 6 (next list row)
        addi	$t3, $t3, 4				# next picture row address ($t3 = $t3 + 4)
        addi	$s4, $s4, 1				# counter_row++      
        add	$s3, $zero, $s0				# $s3 -> counter_col = cols
        
        j 	loop_row			# }

exit_loop_row: 
 

	########## Calculate column clues list ########## 
 	la	$a1, c_clues			# $a1 -> c_clues address
 	
 
        add	$s3, $zero, $s0			# $s3 -> counter_col = cols
        addi	$s4, $zero, 0			# $s4 -> counter_row = 0
        
loop_col2:	
	beq	$s3, $zero, exit_loop_col2	# while (counter_column!=0) {
	
	add	$t3, $zero, $a0				# $t3 -> current picture row address
	add	$t2, $a1, $zero				# $t2 -> clue_position = current row c_clues address
	
loop_row2:	
	beq	$s4, $s1, exit_loop_row2		# while (counter_row!=row) {
	
	lw	$s5, 0($t3)					# $s5 -> current picture row
	
	addi	$t0, $s3, -1					# Calculating current bit...
	srlv 	$t0, $s5, $t0					# current_row >> (counter_col-1)
	andi	$t0, $t0, 1					# $t0 -> current_bit
	
	beq	$t0, $zero, else2				# if (current_bit != 0) {
	
	addi	$t1, $t1, 1						# $t1 -> clue_counter++
	j	if_exit2					# }

else2:								# else {
	beq	$t1, $zero, if_exit2					# if clue_counter == 0, goto if_exit
	
	sw	$t1, 0($t2)						# store clue_counter into c_clues[current_row][clue_position]
	addi	$t1, $zero, 0						# clue_counter = 0
	addi	$t2, $t2, 4						# clue_position++
 
if_exit2:       						# }
        addi	$s4, $s4, 1					# counter_row++
        addi	$t3, $t3, 4					# next picture row address ($t3 = $t3 + 4)
        j	loop_row2				# }

exit_loop_row2:
	beq	$t1, $zero, next_line2			# if cell in last row is filled, store the current clue_counter	
	sw	$t1, 0($t2)				# store clue_counter into c_clues[current_row][clue_position]
	
	addi	$t1, $zero, 0				# clue_counter = 0

next_line2:       
        addi	$a1, $a1, 64				# c_clues_address << 6 (next list row)
        addi	$s3, $s3, -1				# counter_col--      
        addi	$s4, $zero, 0				# $s4 -> counter_row = 0
        
        j 	loop_col2			# }

exit_loop_col2:

        ########################################################################

        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.

        ###############################################################################
        # Data input.
        ###############################################################################
       .data
# These are for the "dog" nonogram
cols: .word 16
rows: .word 14
picture: .word 0x0d81b, 0x0da5b, 0x07a5b, 0x03e3e, 0x00df0, 0x003f8, 0x0057c, 0x00ffe, 0x01ffe, 0x03fff, 0x07fbf, 0x05c3f, 0x07c3f, 0x383f
               0x0000018, 0x0001ffc, 0x0003ffe, 0x000303f, 0x000143f, 0x0001c3f, 0x000083f,
               0x000083f, 0x008083f, 0x00f081f, 0x00d9c1f, 0x00f943f, 0x18f007e, 0x11e00fc,
               0x13f01ec, 0x1ff81ff, 0x0ff81ff, 0x0fcc003, 0x070000d, 0x060000c, 0x060000c,
               0x060000c, 0x030001c 

# You can relly on these all being 0s!
r_clues: .word 0 : 512 # alocate space for 512 words
c_clues: .word 0 : 512 # alocate space for 512 words 
# Where does 512 come from: 
#  The maximum puzle dimension is 32, so in the worst case there can be 16 *single* boxes
#   filled in, i.e. the row/column hint would be: 1, 1, ... ,1   16 times
#  That is the max number of hint numbers possible.
#  Each number is a word (32b - 4 bytes), therefore for each row/column we need to have
#  space for 16 words (= 64 bytes).
#  Multiply this by the max number of rows/columns (32) : 16 words * 32 = 512 words (2Ki bytes) 
