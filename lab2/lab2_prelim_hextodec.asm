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
	
	la $a0, string
	li $a1, 9
	li $v0, 8
	syscall
	
	jal convertHextoDec
	
	move $s0, $v0

	la $a0, dec
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 36
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



convertHextoDec: 	# precondition : $a0 contains the address of a null terminated string
	
	move $s0, $a0
	li $v0, 0

convert:
	lbu $s7, 0($s0)
	beq $s7, 0xa, convert_done
	beq $s7, $0, convert_done
	bgt $s7, '9', biggerThan10
	addi $s6, $0, '0'
	sub $s7, $s7, $s6
	j convertCont
	
biggerThan10:
	addi $s6, $0, 'A'
	sub $s7, $s7, $s6
	addi $s7, $s7, 10
				# $s7 contains the value of the character (0-15)
	
convertCont:	
	sll $v0, $v0, 4
	add $v0, $v0, $s7
	addi $s0, $s0, 1
	j convert
	
convert_done:
	
	jr $ra
	

	.data
string: 	.space 8
menu: 		.asciiz "Enter the hex number to be converted to decimal: "
dec:		.asciiz "Decimal equivalent: "
cont:		.asciiz "If you want to continue please enter y: "
