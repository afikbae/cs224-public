##
##	CS224 Spring 2024
##	Lab 3
##	Section 1
##	Mehmet Akif Şahin
##	22203673	
##	02 / 03 / 2024
##

	.text
	
main_start:
	la $s0, main_start
	la $s1, end

	li $v0, 4
	la $a0, between
	syscall
	li $v0, 4
	la $a0, address1
	syscall
	li $v0, 34
	move $a0, $s0
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	li $v0, 4
	la $a0, address2
	syscall
	li $v0, 34
	move $a0, $s1
	syscall
end:
	li $v0, 11
	li $a0, '\n'
	syscall
	
	move $a0, $s0
	move $a1, $s1
	jal count
	
	move $s0, $v0
	
	li $v0, 4
	la $a0, numberof
	syscall

	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall

	li $v0, 11
	li $a0, '\n'
	syscall

	la $s0, count_start
	la $s1, count_end

	li $v0, 4
	la $a0, between
	syscall
	li $v0, 4
	la $a0, address1
	syscall
	li $v0, 34
	move $a0, $s0
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	li $v0, 4
	la $a0, address2
	syscall
	li $v0, 34
	move $a0, $s1
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	move $a0, $s0
	move $a1, $s1
	jal count
	
	move $s0, $v0
	
	li $v0, 4
	la $a0, numberof
	syscall

	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall

	li $v0, 10
main_end:
	syscall

	
count:
count_start:

	addi $sp, $sp, -16
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	


	move $s0, $a0
	move $s1, $a1

	# i need to look for and, ori, lw
	# and: opcode = 000000, func = 100000
	# ori: opcode = 100101 
	# lw:  opcode = 100011 
	
	addi $s0, $s0, -4
	addi $v0, $0, 0

loop_start:

	addi $s0, $s0, 4

	bgt $s0, $s1, count_finish


	lw $s2, 0($s0)
	li $s3, 0xFC000000
	and $s3, $s3, $s2

	beq $s3, $0, rtype
	beq $s3, 0x34000000, increment
	beq $s3, 0x8C000000, increment
	j loop_start

rtype:
	li $s3, 0x0000003F
	and $s3, $s3, $s2
	beq $s3, 0x00000020, increment
	j loop_start

increment:
	addi $v0, $v0, 1
	j loop_start

count_finish:
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

count_end:
		
	.data
between:		.asciiz "The number of and, ori, lw instructions between the two addresses are:\n"
address1: 		.asciiz "Start address: "
address2: 		.asciiz "End address: "
numberof:		.asciiz "Number of and, ori, lw instructions: "		
