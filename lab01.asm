.data

arr:	.space 16  #This is 16 bytes, or 4 words
messg1:	.asciiz "Please enter a number: "
colon:  .asciiz ": "
endline:.asciiz "\n"

messg2: .asciiz "\nWhich element of the array would you like this to be?: "

	.text 
main:	

	#print first propmpt to user
	la	$a0, messg1		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#this will read my first integer
	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				#make the system call
	add $t0, $v0, $zero		#move number that was just entered into register $t0
	
	#print 2nd prompt to user
	la	$a0, messg2		#Set up my 2nd message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	#this will read my 2nd integer[element]
	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				#make the system call
	add $t1, $v0, $zero		#move number that was just entered into register $t1
	
	#this will store the input into the array
	la $s0, arr			#set up my array as an argument
	mul $t1, $t1, 4 		#multiply input by 4
	add $a1, $s0, $zero
	add $a2, $t1, $s0		#stores the array into a temp register
	sw $t0, 0($a2) 			#this will replace T0 with the input
	
	#print my index
	la	$a0, 0			#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 1		#Specify system call 4 to print
	syscall				#make the system call
	
	#print colon
	la	$a0, colon		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print 0 element
	addi	$v0, $zero, 1		#Specify system call 1 to print integer
	lw $a0, 0($a1)			#loads the first element of the array (0-3)
	syscall
	
	#print new line
	la	$a0, endline		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print the first element
	la	$a0, 1			#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 1		#Specify system call 4 to print
	syscall				#make the system call
	
	#print the colon
	la	$a0, colon		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print 1 element
	addi	$v0, $zero, 1		#Specify system call 1 to print integer
	lw $a0, 4($a1)			#loads the first element of the array (4-7)
	syscall
	
	#print new line
	la	$a0, endline		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
				
	#print my index
	la	$a0, 2			#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 1		#Specify system call 4 to print
	syscall				#make the system call
	
	#print colon
	la	$a0, colon		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print 2 element
	addi	$v0, $zero, 1		#Specify system call 1 to print integer
	lw $a0, 8($a1)			#loads the first element of the array (4-7)
	syscall
	
	#print new line
	la	$a0, endline		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print my index
	la	$a0, 3			#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 1		#Specify system call 4 to print
	syscall				#make the system call
	
	#print colon
	la	$a0, colon		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	#print 3 element
	addi	$v0, $zero, 1		#Specify system call 1 to print integer
	lw $a0, 12($a1)			#loads the first element of the array (4-7)
	syscall
	
	#print new line
	la	$a0, endline		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call
	