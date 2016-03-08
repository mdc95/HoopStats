.data
	.align 2
	newLine: .asciiz "\n"
	endFile: .asciiz "DONE\n"
	head: .word 0 #address of the first node
	string: .space 80
	space: .asciiz " "
	name: .asciiz "Enter name: "
	ppg: .asciiz "Enter points per game: "
	jersey: .asciiz "Enter jersey number: "

.text


main:

#counter
	li $s3, 0

	la $a3, space
#Create head #s0
#-----------------------------------------

#print command
	li $v0, 4
	la $a0, name
	syscall
	
#allocate memory
	li $v0, 9
	li $a0, 88
	syscall
#saving address of space for string
	move $s0, $v0
	li $v0, 8
	la $a0, 0($s0)
	li $a1, 80
	syscall
#the adress of the string is in $s0

#remove the newline character
	la $a0, 0($s0)
	jal removeNewLine


	li $v0, 4
	la $a0, jersey
	syscall
	
	li $v0, 5 
	syscall
	move $a0, $v0
	move $t0, $a0 #move value of jersey number to a0
	
	li $v0, 4
	la $a0, ppg
	syscall
	
	li $v0, 5 
	syscall
	move $a0, $v0 #move value of ppg to a1
	move $t1, $a0

	sub $t2, $t0, $t1 #s1 is JPG; jnumber - ppg	

	sw $t2, 80($s0) #put JPG in
	sw $0, 84($s0) #set pointer to null
	move $s1, $s0 #s0 is the head

#update counter
	addi $s3, $s3, 1

	j main_loop

#-----------------------------------------

	main_loop:
	
#print command
	li $v0, 4
	la $a0, name
	syscall
	
#allocate memory
	li $v0, 9
	li $a0, 88
	syscall
#saving address of space for string
	move $s2, $v0
	li $v0, 8
	la $a0, 0($s2)
	li $a1, 80
	syscall
#the adress of the string is in $s2

	#create counter to keep track of 

#CHECK
	la $a0, 0($s2)
	la $a1, endFile
	jal compare
	main_check:
	beq $v0, $0, prepLoop

	la $a0, 0($s2)
	jal removeNewLine1

	li $v0, 4
	la $a0, jersey
	syscall
	
	li $v0, 5 
	syscall
	move $t0, $v0 #move value of jersey number to s5
	
	li $v0, 4
	la $a0, ppg
	syscall
	
	li $v0, 5 #PPG
	syscall
	move $t1, $v0 #move value of ppg to s6

	sub $t2, $t0, $t1 #s0 is JPG; jnumber - ppg	

	sw $t2, 80($s2) #put JPG in

	
	sw $0, 84($s2) #set next pointer to null
	sw $s2, 84($s1) 
	move $s1, $s2 

	#update counter
	addi $s3, $s3, 1
	
	j main_loop



prepLoop:
	li $s4, 0 #counter


endLoop:
	move $s5, $s0 #s5 points to min
	move $s6, $s0 #s6 is the runner
	beq $s4, $s3, end_actual

	findMinLoop:
		#While runner has next
		beqz $s6, movePoint
		
		lw $t0, 80($s6) #runner
		lw $t1, 80($s5) #min
		#if runner.val < min, t2 = 1
		slt $t2, $t0, $t1
		bnez $t2, updateMin

		lw $s6, 84($s6) #update next
		j findMinLoop


		

updateMin:
	move $s5, $s6
	lw $s6, 84($s6) #update next
	j findMinLoop

movePoint:
	#update counter
	addi $s4, $s4, 1
	
	#print s5
	jal print_func

	#change the value of s5 
	li $t1, 1000000
	sw $t1, 80($s5)
	j endLoop


removeNewLine:

	lbu $t0, 0($a0)
	addi $a0, $a0, 1
	bne $t0, $0, removeNewLine

	addi $a0, $a0, -2
	
	sb $0, 0($a0)
	j end_function

removeNewLine1:

	lbu $t0, 0($a0)
	addi $a0, $a0, 1
	bne $t0, $0, removeNewLine

	addi $a0, $a0, -2
	
	sb $0, 0($a0)
	j end_function




	#--------------------------
	#check if file is endFile
	compare:
		addi $t1, $a0, 0
		addi $t2, $a1, 0
	compareLoop:
		lbu $t3($t1) #takes first byte from name
		lbu $t4($t2)
		beqz $t3, check_Done #check for mismatch

		beqz $t4, notSame #check for mismatch
		slt $t5, $t3, $t4
		bnez $t5, notSame
		addi $t1, $t1, 1 #move to next byte
		addi $t2, $t2, 1 #move to the next byte
		j compareLoop
	check_Done:
		bnez $t4, notSame
		li $v0, 0 
		j end_function
	notSame:
		li $v0, 1
		j end_function #jump back to main func
	#--------------------------


	print_func:

			 		#print name		
			li $v0, 4
			la $a0, 0($s5)
			syscall
			
			 #print space
			li $v0, 4
			la $a0, space
			syscall
			
			 #print JPG
			li $v0, 1
			lw $a0, 80($s5)
			syscall 

			li $v0, 4
			la $a0, newLine
			syscall

			j end_function



	end_actual:
		li $v0, 10
		syscall

end_function:
	jr $ra

