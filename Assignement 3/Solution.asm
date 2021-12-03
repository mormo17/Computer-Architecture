.data
InputText: .asciiz "Please enter the word: "
CorrectText: .asciiz "Word is palindrome"
FalseText: .asciiz "Word is not palindrome."
allocatedSpace: .space 21
.text
main:

la $a0, InputText	#
li $v0, 4		# show InitialText input
syscall			#

add $t0, $zero, $zero	# initially load 0 

li  $v0, 8          #gets input word
la  $a0, allocatedSpace
la  $a1, 22
syscall


computeLength:
    lb  $s0, allocatedSpace($t0)  #load each character to s0

    beq $s0, '\0', Iterate 

    add $t0, $t0, 1	# increment counter of length
j computeLength

Iterate:
	la $t3, 1		# initially answer is True
	
	sub $t0, $t0, 1		# word's length
	la $t1, 0		# load i to be 0
	
	sub $t2, $t0, $t1	# load j to be length - i - 1
	sub $t2, $t2, 1		#
	
	div $t4, $t0, 2		# length / 2
	mfhi $t5		# remainder
	add $t4, $t4, $t5	# if length is word $t4 = (length/2) + 1
	
	
	
	loop:
	beq $t4, $t1, printAnswer	# if i == length
	
	lb $s0, allocatedSpace($t1)	# word[i]
	lb $s1, allocatedSpace($t2)	# word[length - i - 1]
	
	bne $s0, $s1, loadFalse
	
	add $t1, $t1, 1			# i++
	sub $t2, $t2, 1			# j--
	j loop
	
	
	loadFalse:
		la $t3, 0
		j printAnswer
		
	printAnswer:
	beq $t3, 0, printFalseAnswer
	
	la $a0, CorrectText	#
	li $v0, 4		# show InitialText input
	syscall			#
	j exit
	
	li $v0, 10	#
			#	exit
	syscall		#
	
	printFalseAnswer:
		
	la $a0, FalseText	#
	li $v0, 4		# show InitialText input
	syscall			#
	j exit
	
	exit:	
	li $v0, 10	#
			#	exit
	syscall		#
