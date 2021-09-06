.data
arr:	.space 4000	#This is 4000 bytes, or 1000 pairs
endline: .asciiz "\n" 
tab: .asciiz "\t" 

.text 
main:	
	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				#make the system call
	add 	$t0, $v0, $zero		#store number of coordinates into register $t0
	
	addi 	$t1, $zero, 2		#add immediate $t1 for each 2 entries
	mul 	$t2, $t0, $t1 		#multiply to values in $t1 and $t0 and store into $t2
	sub 	$a2, $t2, $t1		#setting $a2 to the n inputs- 2
	add 	$t3, $zero, $zero	#set $t3 to 0
	add 	$t8, $zero, $zero	#set $t8 to 0
	addi 	$t6, $zero, 4		#add immediate 4 into $t6
	addi 	$t4, $zero, 1		#add immediate 1 into $t4	
#-------------------------------------------------------------------------------------------------------------------
	#this reads out inputs and puts them into an array
reader:
	beq	$t3, $t2, bubblesort	#if the first number and number of pais is equal, bubble sort them
	addi	$v0, $zero, 5		#set up syscall to read number input
	syscall				#make the system call
	add 	$t4, $v0, $zero		#add inpout into $t4
	mul 	$t5, $t3, $t6		#multiplies the values in $t3 and $t6 into $t5
	sw 	$t4, arr($t5)		#store word current input into $t4	
	addi 	$t3, $t3, 1		#add immediate to add 1 to value in $t3
	addi 	$t4, $zero, 1		#add immediate and store 1 into $1
	j reader			#jump to reader(loop)
#-------------------------------------------------------------------------------------------------------------------
	#our bubblesort function
bubblesort: 
	add 	$t3, $zero, $zero	#set $t3 to 0
	beq 	$t8, $a2, ordered	#if branch equals the values in $t8 and $a2, go to the ordered function
	mul 	$t7, $t8, $t6 		#multiply values in $t6 and $t8 and store them into $t7
	lw 	$s0, arr($t7) 		#load word of value in $t7 into $s0
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	lw 	$s1, arr($t7) 		#load word of value in $t7 into $s1
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	lw 	$s2, arr($t7) 		#load word of value in $t7 into $s2
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	lw 	$s3, arr($t7) 		#load word of value in $t7 into $s3
	mul 	$s4, $s0, $s0		#square the vlaue in $s0 and store into $s4
	mul 	$s5, $s1, $s1		#square the vlaue in $s1 and store into $s5
	add 	$s4, $s4, $s5		#add the current values in $s4 and $s5 and store into $s4
	mul 	$s5, $s2, $s2		#square the vlaue in $s2 and store into $s5
	mul 	$s6, $s3, $s3		#square the vlaue in $s3 and store into $s6
	add 	$s5, $s5, $s6		#add the current values in $s6 and $s5 and store into $s5
	beq 	$s5, $s4, comparexcoord	#branch equals if values in $s5 and $s4 are equal, compare x coords
	slt 	$s6, $s5, $s4		#set $s6 equal to value in $s5 if its value is less than the value in $s4
	addi 	$s7, $zero, 1		#set $s7 to 1
	beq 	$s6, $s7, swappingcoord	#branch equals if values in $s6 and $s7 are equal, swap the coords
	addi 	$t8, $t8, 2		#add immediate to add 2 to current value in $t8
	j bubblesort			#jump back up to bubblesort function
#-------------------------------------------------------------------------------------------------------------------
	#this function will compare our x coords are the same
comparexcoord:
	beq 	$s0, $s2, compareycoord	#if x coords are the same, go to compareycoord function
	slt 	$s6, $s2, $s0		#set $s6 if values in $s2 is less than value in $s0
	addi 	$s7, $zero, 1		#add immediate to set true in $s7
	beq 	$s6, $s7, swappingcoord	#if the branch equal of values in $s6 and $s7
	addi 	$t8, $t8, 2		#add immediate to add 2 to value in $t8
	j bubblesort			#jump to bubblesort function
#-------------------------------------------------------------------------------------------------------------------	
	#function to compare y coords if the x coods are the same
compareycoord:
	slt 	$s6, $s3, $s1		#set $s6 if the value in $s3 is less than the value in $s1
	addi 	$s7, $zero, 1		#set $s7 to 1
	beq 	$s6, $s7, swappingcoord	#swapping the coordinates if branch equal $s6 is 1
	addi 	$t8, $t8, 2		#add immediate to add 2 to current value in $t8
	j bubblesort			#jump to bubblesort function
	#this function will swap the corrdinated 
swappingcoord: 
	add 	$t4, $zero, $zero	#set t4 to zero, meaning nothing has been swapped
	mul 	$t7, $t8, $t6 		#multiply the values in $t6 and $t8 and store them into $t7
	sw 	$s2, arr($t7) 		#store word the current value in array into $s2
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	sw 	$s3, arr($t7) 		#store word the current value in array into $s3
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	sw 	$s0, arr($t7) 		#store word the cureent value into $s0
	addi 	$t7, $t7, 4		#add immediate to add 4 to current value in $t7
	sw 	$s1, arr($t7) 		#store word the current value in array into $s1
	addi 	$t8, $t8, 2		#add immediate to add $t8 by 2
	j bubblesort			#jump to bubblesort function
#-------------------------------------------------------------------------------------------------------------------	
	#prints the pairs if the coordinates were swapped.
ordered:
	bne 	$t4, $t3, output	#if values at $t4 and $t3 are not equal go to output function
	add 	$t8, $zero, $zero	#will set the value in $t8 back to 0
	addi 	$t4, $zero, 1		#stores the value 1 into $t4
	j bubblesort			#jump to bubblesort function
#-------------------------------------------------------------------------------------------------------------------
	#this will print out our bubblesorted ordered pairs
output:
	beq 	$t3, $t2, exit		#if values in $t3 and $t2 are equal, exit the program
	mul 	$t7, $t3, $t6		#multiply values in $t3 and $t6 and store into $t7
	lw 	$t9, arr($t7)		#load word of value in $t7 into $t9
	
	li 	$v0, 1			#load immediate to print integer
	add 	$a0, $t9, $zero		#setting up to print integer
	syscall				#make the system call
	
	la 	$a0, tab		#load address of tab
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call
	
	addi 	$t3, $t3, 1		#addi immediate to go up 1
	mul 	$t7, $t3, $t6 		#multiply values in $t3 and $t6 and store into $t7
	lw 	$t9, arr($t7)		#load word of value in $t7 into $t9
	
	li 	$v0, 1			#load immediate to print integer
	add 	$a0, $t9, $zero		#print integer	
	syscall				#make the system call
	
	addi 	$t3, $t3, 1		#addi immediate to go up 1
	la 	$a0, endline		#load adress of endline
	addi 	$v0, $zero, 4		#specify system call 4 to print
	syscall				#make the system call
	
	j output			#jump to output funtion
#-------------------------------------------------------------------------------------------------------------------	
	#This will exit the program when finished sorting the array
exit:	
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call