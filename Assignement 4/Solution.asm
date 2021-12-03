.data 
firstArray: .space 512
secondArray: .space 512
FirstMessage: .asciiz "Enter number of sequence: " 
toAdd: .asciiz "Enter number you want to add to sequence: "
.text

#################### main ####################
	main:
	j readFromConsole


#################### reads input from console and saves N in $t0 ####################
	readFromConsole:
		la $a0, FirstMessage	#
		li $v0, 4		# show FirstMessage
		syscall			#
	
		li $v0, 5		#
		syscall			# read input
		move $t0, $v0		#

		lw $t1, firstArray	# point $t1 to allocated array
		la $t2, 0		# load i to be zero

		
#################### fills array with N inputted numbers ####################
	fillArray:
		while:
			beq $t0, $t2, loadVariablesForOuterLoop	#	loop N times
			
			la $a0, toAdd		#
			li $v0, 4		#	show toAdd message
			syscall			#
			
			li $v0, 5		#
			syscall			#	read input
				
			sw $v0, firstArray($t1)	#	move inputted integer into array
			
			addi $t1, $t1, 4	#	pointer += 4
			addi $t2, $t2, 1	#	i++
			
			j while
			
	loadVariablesForOuterLoop:
		la $t2, 0		# load i to be zero
		la $t1, firstArray	# point $t1 to allocated array
		la $t6, secondArray	# point $t6	 to allocated array		
		
	OuterForLoop:		
		beq $t0,$t2, loadVariablesForLastLoop	#	loop N times
		
		la $t3, ($t2)		# 	let $t3 = i
		add $t3, $t3, $t3	#	double the index
		add $t3, $t3, $t3	# 	double the index again (now 4x)
		
		add $t8, $t1, $t3	#	get real address of i'th element - firstArray
		add $t4, $t6, $t3	#	get real address of i'th element - secondArray
		lw $t9, 0($t8)		#	save firstArray[i]
		
		la $t5, 1
		sw $t5, 0($t4)		#	let secondArray[i] = 1
			loadVariablesForInnerLoop:
				la $t7, 0		# load j to be zero
				innerForLoop:
					beq $t2, $t7, innerForLoopEnd	# 	loop i times
					
					la $t3, ($t2)		# 	let $t3 = i
					add $t3, $t3, $t3	#	double the index
					add $t3, $t3, $t3	# 	double the index again (now 4x)
					add $t4, $t6, $t3	#	get real address of i'th element - secondArray
					lw $t5, 0($t4)		#	save secondArray[i]
					
					la $t3, ($t7)		# 	let $t3 = j
					add $t3, $t3, $t3	#	double the index
					add $t3, $t3, $t3	# 	double the index again (now 4x)
					
					add $t8, $t1, $t3	#	get real address of j'th element - firstArray
					add $s4, $t6, $t3	#	get real address of j'th element - secondArray
					lw $s1, 0($t8)		#	save firstArray[j]
					lw $t3, 0($s4)		#	save secondArray[j]
					
					bgt $t9, $s1, changeSecondArray				
					branchEnd:
					
					addi $t7, $t7, 1	#	j++
					j innerForLoop
		
		
		innerForLoopEnd:
		addi $t2, $t2, 1	#	i++
		j OuterForLoop

	
#################### secondArray[i] = max(secondArray[i], secondArray[j]+1 ####################
	changeSecondArray:
		la $s2, ($t5)		#	let $s2 be secondArray[i]
		la $s3, ($t3)		#	let $s3 be secondArray[j]	
		addi $s3, $s3, 1	#	let $s3 be secondArray[j] + 1
		j firstMax
		firstMaxEnd:
			sw $s4, 0($t4)	#	let secondArray[i] = max(secondArray[i], secondArray[j] + 1)	
		j branchEnd


#################### writes result of max($s2, $s3) in $s4 ####################
	firstMax:
		bge $s2, $s3, grater
		j else

		grater:
			la $s4, ($s2)
			j firstMaxEnd

		else:
			la $s4, ($s3)
			j firstMaxEnd


#################### writes result of max($s2, $s3) in $s4 ####################
	secondMax:
		bge $s2, $s3, secondGrater
		j secondElse

		secondGrater:
			la $s4, ($s2)
			j secondMaxEnd

		secondElse:
			la $s4, ($s3)
			j secondMaxEnd


#################### calculates what is length of longest increasing subsequence ####################
	loadVariablesForLastLoop:
		la $s2, 0	#	let initially result be 0
		la $t2, 0		# load i to be zero
		lastFor:
			beq $t0, $t2, printAnswer	#	loop N times
	
			la $t3, ($t2)		# 	let $t3 = i
			add $t3, $t3, $t3	#	double the index
			add $t3, $t3, $t3	# 	double the index again (now 4x)
		
			add $t4, $t6, $t3	#	get real address of i'th element - secondArray
			lw $s3, 0($t4)		#	save secondArray[i]
			j secondMax
			secondMaxEnd:
			la $s2, ($s4)
			addi $t2, $t2, 1	#	i++
			j lastFor


#################### prints answer #################### 
	printAnswer:

		li $v0, 1	#
		move $a0, $s2	#	show counter's value
		syscall		#
					
		j exit	


#################### exit ####################
	exit:	
		li $v0, 10	#
				#	exit
		syscall		#