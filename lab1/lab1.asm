.text

	la $a0, expression
	jal print_string
	
	li $a1, 'x'
	jal print_enter
	
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	li $a1, 'y'
	jal print_enter
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
	li $a1, 'z'
	jal print_enter
	
	li $v0, 5
	syscall
	
	move $s2, $v0
	
	beq $s1, $0, error
	beq $s2, $0, error
	j cont

error:
	la $a0, zeroDiv
	jal print_string
	
	li $v0, 10
	syscall

		
cont:
	addi $t0, $s0, 5
	div $t0, $s1
	mfhi $t0
	div $t0, $s2
	mflo $t0
	
	la $a0, result
	jal print_string
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall


print_string:			# precondition: $a0 contains the address of the string
	li $v0, 4
	syscall
	jr $ra

print_enter:			# precondition: $a1 contains the name of the variable as char
	move $t0, $ra
	la $a0, enter
	jal print_string
	
	move $a0, $a1
	li $v0, 11
	syscall
	
	la $a0, enterCont
	jal print_string
	jr $t0

.data
expression: 	.asciiz "The expression ( ( x + 5 ) % y ) / z will be calculated\n"
enter: 		.asciiz "Please enter the value of "
enterCont: 	.asciiz " : "
result: 	.asciiz "The result is : "
zeroDiv: 	.asciiz "Division by 0!!"
