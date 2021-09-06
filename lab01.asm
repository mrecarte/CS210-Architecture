.data
messg1: .asciiz "Enter the 1st number in the sequence: "
messg2: .asciiz "Enter the 2nd number in the sequence: "
messg3: .asciiz "Number of elements of the sequence: "
colon: .asciiz ": "
endline: .asciiz "\n" 
tab: .asciiz "\t"
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
	#print 3rd prompt to user
	la	$a0, messg3		#Set up my 2nd message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	#this will read my 3nd integer[element]
	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				#make the system call
	add $t2, $v0, $zero		#move number that was just entered into register $t1
#--------------------------------------------------------------------------------------------------------------------
	#This will print the term's information 
	li $v0, 1			#Load immediate to print int
	add $a0, $t0, $zero		#adds the first term into register $a1
	syscall				#make the system call
	#this will print the tab
	la $a0, tab			#loads address of the tab
	addi $v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	#this will print the hexadeciaml number
	add $a0, $zero, $t0		#adds the $a0 register to t0
	li $v0, 34			#load immediate call 34 to print the hex
	syscall				#make the system call
	#This will print the tab
	la $a0, tab			#loads adress of the tab
	addi $v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
#--------------------------------------------------------------------------------------------------------------------
	#This will set our binary number to 32
	addi $a2, $zero, 32		#add immediate to set $a2 to 32 which is size of the binary number
	add $a1, $t0, $zero		#loads the 1st input into $a1
	add $a3, $zero, $zero		#makes $a3 equal to 0
	jal BinaryCounter		#jump and link to the funtion that counter the binary number of 1s
	#prints integer
	li $v0, 1			#Setting up to print integer
	add $a0, $a3, $zero		#putting the number of 1 bits(a3) into a0 to print
	syscall				#make the system call
	#this will print the endline
	la $a0, endline			#loads argument of endline
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
#--------------------------------------------------------------------------------------------------------------------	
	#This will print the next number's information
	li $v0, 1			#Load immediate to print int
	add $a0, $t1, $zero		#adds the first term into register $a1
	syscall				#make the system call
	#This will print the tab
	la $a0, tab			#loads address of the tab
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	#This will print the hexadecial number
	add $a0, $zero, $t1	
	li $v0, 34			#load immediate call 34 to print the hex
	syscall				#make the system call
	#This will print the tab
	la $a0, tab			#loads address of the tab
	addi $v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
#--------------------------------------------------------------------------------------------------------------------		
	# Setting up arguments and then calling getOnes to figure out number of bits set to 1
	add $a1, $t1, $zero		#Sets $a1 to the 2nd number
	addi $a2, $zero, 32		#sets the argument $a2 to 32
	add $a3, $zero, $zero		#sets up $a3 to be 0
	jal BinaryCounter		#jumps and links to the Binary counter function
	#this will print the current integer
	li $v0, 1			#Setting up to print integer
	add $a0, $a3, $zero		##sets up the argument in $a3 to $a0
	syscall				#make the system call
	#this will print endline
	la $a0, endline			#loads address of endline
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call	
	addi $t4, $zero, 2		#sets $t4 to 2
	#this will go through the remaining terms that we have no evaluated yet
RemainingTerms:
	bne $t4, $t2, Fibonacci		#will call out Fib if it is not 10
	j exit				#jump to our exit system call
Fibonacci:
	add $t5, $t0, $t1		#set $t5 to the sum of the last to integers	
	add $t0, $t1, $zero		#sets $t0 to the last number before the next number
	add $t1, $t5, $zero		#set $t1 to the value of $t5
#--------------------------------------------------------------------------------------------------------------------	
	#This will print out the terms
	li $v0, 1			#load immediate to print int
	add $a0, $t1, $zero		#sets $t1 to $a0 
	syscall				#make the system call
	la $a0, tab			#loads address of the tab 
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	#this will print the hexadecimal number
	add $a0, $zero, $t1		#sets $a0 to the 2ns unput
	li $v0, 34			#load immediate to print dex number
	syscall				#make the system call
	#this will print the tab
	la $a0, tab			#loads the adress of the tab
	addi $v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	#this will set us up to count the binary number
	add $a1, $t1, $zero		#sets up $a1 equal to the 2nd unput
	addi $a2, $zero, 32		#sets $a2 to 32
	add $a3, $zero, $zero		#setting $a3 to 0
	jal BinaryCounter		#jump and link to count the 1s
	#This will print the integer
	li $v0, 1			#Setting up to print integer
	add $a0, $a3, $zero		#putting the result of the 1 bits calculation into a0
	syscall				#make the system call
	#Thsi will print the endline
	la $a0, endline			#load address of the endline
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	addi $t4, $t4, 1		#This will add 1 to the current number in the $t4 regster
	j RemainingTerms 		#jump to the reamining terms
	#This will count the number of 1s in out binary number
BinaryCounter: 
	addi $t6, $zero, 1 		#add immediate to make $t6 to 1
	and $t5, $a1, $t6		#and funtion pllied to the binary number
	bne $t5, $t6, Shifting		# calls out shifter function if the number is not 1
	addi $a3, $a3, 1		#add 1 the curent value in $a3 
 	j Shifting			#jumps to the function that shifts our bit
 
 	#This will move us through our binary number
Shifting: 
	addi $a2, $a2, -1		#subtracts one from the current bit
	srl $a1, $a1, 1			#shifts to the bit on the right to count is it is a 1
	bne $a2, 0, BinaryCounter	#compares $a2 is 0 cand calls Binary Conter if not 0
	jr $ra				#jump to return address
#--------------------------------------------------------------------------------------------------------------------	 
exit:
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call