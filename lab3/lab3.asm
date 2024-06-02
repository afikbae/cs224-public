##
##	CS224 Spring 2024
##	Lab 3
##	Section 1
##	Mehmet Akif Şahin
##	22203673	
##	02 / 03 / 2024
##

	.text
# CS224, Program to be used in Lab 3
# October 16, 2023

	li	$a0, 10 	#create a linked list with 10 nodes
	jal	createLinkedList
	move 	$s0, $v0
	
		
	# Linked list is pointed by $v0
	move	$a0, $v0	# Pass the linked list address in $a0
	jal 	printLinkedList
	
menu:
	li 	$v0, 4
	la 	$a0, menuLabel
	syscall
	
	li 	$v0, 12
	syscall
	move $s7, $v0
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
case_a:
	bne $s7, 'a', case_b

	move $a0, $s0

	jal displayReverseOrderRecursively
	j menu
case_b:
	bne $s7, 'b', case_c
	move $a0, $s0
	jal duplicateListIterative
	move $a0, $v0
	jal printLinkedList
	j menu
case_c:
	bne $s7, 'c', default
	move $a0, $s0
	jal duplicateListRecursive
	move $a0, $v0
	jal printLinkedList
	j menu
default:
	li	$v0, 10
	syscall	
	

	
# Stop. 
	li	$v0, 10
	syscall	
#=========================================================
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	move	$s4, $s1	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	move	$s4, $s1	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
	
	
displayReverseOrderRecursively:
	
	addi $sp, $sp, -12
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	bne $a0, $0, cont
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
cont:
	move $s1, $a0
	lw $a0, 0($a0)
	jal displayReverseOrderRecursively
	
	lw $s0, 4($s1)
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 11
	li $a0, ' '
	syscall
	
	addi $sp, $sp, 12
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	
	jr $ra
	
duplicateListIterative:

	# given $a0 -> address of first element
	# linked list structure: $a0 -> [ next, value ]
	
	addi $sp, $sp, -20 
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0

	li $v0, 9
	li $a0, 8
	syscall

	move $s1, $v0 # head 
	move $s2, $v0 

	lw $0,  0($s2)
	lw $s3, 4($s0)
	sw $s3, 4($s2)

	j condition

loopBegin:
	li $v0, 9
	li $a0, 8
	syscall
	sw $v0, 0($s2)

	lw $s2, 0($s2)
	lw $s0, 0($s0)

	lw $0,  0($s2)
	lw $s3, 4($s0)
	sw $s3, 4($s2)

condition:
	lw $s3, 0($s0)
	bne $s3, $0, loopBegin

	move $v0, $s1

	lw $ra, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20 
	
	jr $ra

duplicateListRecursive:		# $a0 contains source, $a1 contains new

	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0
	move $s1, $a1

	lw $s2, 0($s0)
	bne $s2, $0, notbase
	j return
notbase:
	bne $s1, $0, notfirst
	li $v0, 9
	li $a0, 8
	syscall
	move $s1, $v0
	move $s3, $v0
	lw $0, 0($s1)
	lw $s2, 4($s0)
	sw $s2, 4($s1)

	move $a0, $s0
	move $a1, $s1
	
	jal duplicateListRecursive
	move $v0, $s3
	j return
notfirst:

	li $v0, 9
	li $a0, 8
	syscall
	sw $v0, 0($s1)
	lw $s1, 0($s1)
	sw $0, 0($s1)
	lw $s0, 0($s0)
	lw $s2, 4($s0)
	sw $s2, 4($s1)
	
	move $a0, $s0
	move $a1, $s1

	jal duplicateListRecursive
	j return
return:
	lw $ra, 16($sp)
	sw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20

	jr $ra


#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
menuLabel:
	.ascii 	"\n a) Display Linked List in Reverse Order"
	.ascii 	"\n b) Duplicate Linked List Iteratively"
	.ascii 	"\n c) Duplicate Linked List Recursively"
	.asciiz "\n Please enter your choice (any other will terminate): "
