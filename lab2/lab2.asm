##
##	CS224 Spring 2024
##	Lab 2
##	Section 1
##	Mehmet Akif Şahin
##	22203673	
##	25 / 02 / 2024
##
	
	.text
	
	li $v0, 4
	la $a0, arraySizePrompt
	syscall
	
	li $v0, 5
	syscall
	
	sll $s1, $v0, 2
	move $a0, $s1
	li $v0, 9
	syscall
	
	sra $s1, $s1, 2
	move $s0, $v0

	move $a0, $s0
	move $a1, $s1
		
	jal monitor
	
	move $s6, $v0
	move $s7, $v1
	
	li $v0, 4
	la $a0, arrayElements
	syscall
	
	addi $s2, $0, 0
	
printStart:
	sll $s3, $s2, 2
	add $s3, $s3, $s0
	
	lw $a0, 0($s3)
	li $v0, 1
	syscall
	
	la $a0, ' '
	li $v0, 11
	syscall
	
	addi $s2, $s2, 1
	
	blt $s2, $s1, printStart
	
	la $a0, '\n'
	li $v0, 11
	syscall
	
	li $v0, 4
	la $a0, minmaxPrompt
	syscall
	
	move $a0, $s6
	li $v0, 1
	syscall
	
	la $a0, ' '
	li $v0, 11
	syscall
	
	move $a0, $s7
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	
	
	
	
monitor:	# precondition : $a0 contains array address, $a1 contains array size
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	li $s2, 0
	
inputStart:
	
	li $v0, 4
	la $a0, arrayInputPrompt
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, arrayInputPromptCont
	syscall
	
	li $v0, 5
	syscall
	
	sll $s3, $s2, 2
	add $s3, $s3, $s0
	sw $v0, 0($s3)
	
	addi $s2, $s2, 1
	blt $s2, $s1, inputStart 
	
	move $a0, $s0
	move $a1, $s1
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal bubbleSort
	
	move $a0, $s0
	move $a1, $s1
	
	jal minMax
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
bubbleSort:
	
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	addi $s5, $0, 0
	
outerLoop:
	addi $s0, $a1, -1
	beq $s5, $s0, doneOuter
	addi $s4, $s0, 0
	addi $s6, $0, 1
	
innerLoop:
	sub $s0, $a1, $s5
	beq $s6, $s0, doneInner 
	
	addi $s0, $s6, -1
	sll $s0, $s0, 2
	add $s0, $a0, $s0
	lw $s2, 0($s0)
	sll $s1, $s6, 2
	add $s1, $a0, $s1
	lw $s3, 0($s1)

	bgt $s2, $s3, swap
	j swapEnd
swap:
	sw $s3, 0($s0)
	sw $s2, 0($s1)
	addi $s4, $0, 1
swapEnd:


	addi $s6, $s6, 1
	j innerLoop
doneInner:
	addi $s5, $s5, 1
	beq $s4, $0, doneOuter
	j outerLoop
doneOuter:
	
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
minMax:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	lw $v0, 0($a0) 
	
	addi $a1, $a1, -1
	sll $s0, $a1, 2
	add $s0, $s0, $a0
	
	lw $v1, 0($s0)
	
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	
	
	
	.data
	
arraySizePrompt: 	.asciiz "Enter the array size : "
arrayInputPrompt: 	.asciiz "Enter array["
arrayInputPromptCont: 	.asciiz "] : "
arrayElements:	 	.asciiz "Sorted array elements are: "
minmaxPrompt: 		.asciiz "Min and max elements are respectively: "