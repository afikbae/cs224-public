

##
##	CS224 Spring 2024
##	Lab 2
##	Section 1
##	Mehmet Akif Şahin
##	22203673	
##	25 / 02 / 2024
##

	.text

start:
	la $a0, menu
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	la $a0, decrep
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 34
	syscall
	
	la $a0, '\n'
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal invertBytes
		
	move $s0, $v0
	
	la $a0, res
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 34
	syscall
	
	la $a0, '\n'
	li $v0, 11
	syscall
	
	la $a0, cont
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	
	move $s0, $v0
	
	la $a0, '\n'
	li $v0, 11
	syscall
	
	beq $s0, 'y', start
				
	li $v0, 10
	syscall	
	
	
	
	
	
	
invertBytes:			# precondition: $a0 contains the word to be inverted
	li $s0, 0xff000000
	li $s1, 24
	li $s6, 0
	li $s7, 4
	li $v0, 0
while:
	and $s2, $a0, $s0
	srlv $s2, $s2, $s1
	sllv $s2, $s2, $s6
	or $v0, $v0, $s2
	srl $s0, $s0, 8
	addi $s1, $s1, -8
	addi $s6, $s6, 8
	addi $s7, $s7, -1
	bne $s7, $0, while
	jr $ra
	
	.data
menu: 		.asciiz "Enter the number to be inverted: "
decrep: 	.asciiz "Hexadecimal representation of the input: "
res: 		.asciiz "Inverted: "
cont: 		.asciiz "Want to continue (enter y): "