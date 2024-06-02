##
##	CS224 Spring 2024
##	Lab 3
##	Section 1
##	Mehmet Akif Şahin
##	22203673	
##	02 / 03 / 2024
##
	.text
start:
	li $v0, 4
	la $a0, enterx
	syscall	
	
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	li $v0, 4
	la $a0, entery
	syscall	
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
	beqz $s1, divZero
	
	move $a0, $s0
	move $a1, $s1
	jal divide
	move $s2, $v0
	
	li $v0, 4
	la $a0, result
	syscall	
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
		
askCont:
	li $v0,	4
	la $a0, con
	syscall	
	
	li $v0, 12
	syscall
	
	move $t0, $v0
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	beq $t0, 'y', start
	
	li $v0, 10
	syscall
	
divZero:
	li $v0, 4
	la $a0, divZeroText
	syscall	
	j askCont


	
divide: 	# $a0 / $a1
	blt $a0, $a1, divbase
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	sub $a0, $a0, $a1
	jal divide
	addi $v0, $v0, 1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
divbase:
	li $v0, 0
	jr $ra
	
	.data
enterx: 	.asciiz "enter the value of x: "
entery: 	.asciiz "enter the value of y: "
result:		.asciiz "the result x / y = "
con: 		.asciiz "do you want to continue (enter y) ? "
divZeroText:	.asciiz "you cannot divide by zero\n"