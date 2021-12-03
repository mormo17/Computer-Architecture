.data
number: .asciiz "Enter integer: "
space: .asciiz " "
enter: .asciiz "\n"

.text

	main:
	la, $a0, number
	li, $v0, 4
	syscall
		
	li $v0, 5 #read input
	syscall
	move $t1, $v0 #save input
	
	la $t0, 0 #load counter's address
	
	loop:
	beq $t1, 1, break
	
	li $v0, 1     	#
	move $a0, $t1 	#	show $t1 value
	syscall		#	
	
	la, $a0, space 	#
	li, $v0, 4	#	show space
	syscall		#
	
	add $t0, $t0, 1 #increment counter
	
	rem $t2, $t1, 2
	
	
		
	beq $t2, 0, even
	jal odd
	
	even:
	div $t1, $t1, 2
	j loop
	
	odd:	
	mul $t1, $t1, 3
	add $t1, $t1, 1	
	j loop
	
	
	break:
	la, $a0, enter	#
	li, $v0, 4	#	newline
	syscall		#
		
	li $v0, 1	#
	move $a0, $t0	#	show counter's value
	syscall		#
	
	li $v0, 10	#
			#	exit
	syscall		#
