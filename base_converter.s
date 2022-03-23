###################################################
#	sdi1800142 									  #
#	Theodora Panteliou						      #
#	kathgoria A-Thema 2o						  #
###################################################
###################################################
#												  #
#					text segment			      #
#												  #
###################################################

	.text		
    .globl __start
__start:	
			
bigloop:

la $a0, givebase
li $v0, 4			#print string
syscall

loopforvalidbase:
	li $v0, 5			#read integer(integer in $v0)
	syscall
	add $a0, $v0, $zero			#move integer to $a0
	li $v0,1 #print int
    syscall	
	move $s0, $a0 ##################base in s0
	
	la $a0, endl
	li $v0, 4			#print endl
	syscall
	
	li $t0, 2
	li $t1, 10
	beqz $s0, exit
	blt $s0, $t0, invalidbase
	bgt $s0, $t1, invalidbase
	j exitloopforvalidbase
	invalidbase:
		la $a0, wrongbase
		li $v0, 4			#print string
		syscall
	j loopforvalidbase
	
exitloopforvalidbase:
	
la $a0, givenumber
li $v0, 4			#print string
syscall
move $a0, $s0
li $v0, 1
syscall
la $a0, cont
li $v0, 4			#print string
syscall


loopnumber:	
	li $v0, 8			#read string of 5 characters
	la $a0, str
	li $a1, 6
	syscall
	li $v0, 4			#print string
	la $a0, str
	syscall
	la $a0, endl
	li $v0, 4			#print endl
	syscall
	
	li $t1,0 # str index
	li $t2,10 # end character '\n'
	addi $t3, $s0, 47
	loop:lbu $t0,str($t1) #t0=char
		beq $t0,$t2,exitloop #if char==10
		beqz $t0, exitloop #or if char==null exit
			li $t5, 48 #char 0
			blt $t0, $t5, invalidchar
			bgt $t0, $t3, invalidchar
			
			addi $t1,$t1,1 #next char
		j loop 
	exitloop: 
	j exitloopnumber
	invalidchar:
	li $v0, 4			#print string
	la $a0, wrongnum
	syscall
	j loopnumber
exitloopnumber:

move $s2, $t1 #save # of chars== # of digits

#convert string to int
li $s3, 0 ##########################result
li $t1,0 #str index
li $t2,10 #end character '\n'

#1*6^4+2*6^3+2*6^2+4*6^1+5*6^0
loop2:lbu $t0,str($t1) 
	beq $t0,$t2,exitloop2
	beqz $t0, exitloop2
		addi $s2, -1 #weight
		#char to digit t3
		addi $t3, $t0, -48
		#digit to number
		#power
		move $t4, $s2
		li $t5, 1 #base for multiplication
		power:
			beqz $t4, exitpower
			mult $t5, $s0
			mflo $t5
			addi $t4, -1
			j power
		exitpower:
		
		mult $t5, $t3
		mflo $t5
		add $s3, $s3, $t5 #add to result
		
	addi $t1,$t1,1 #next char
	j loop2 
exitloop2: 
li $v0, 4			#print string
la $a0, decimal 
syscall
move $a0, $s3
li $v0, 1
syscall
li $v0, 4			#print string
la $a0, endl		#print endl
syscall

j bigloop
exit:	
li $v0, 4			#print string
la $a0, exiting 
syscall
	li $v0,10
	syscall
			
.data
givebase: .asciiz "Give base:\n"
wrongbase: .asciiz "Wrong base; give again:\n"
endl: .asciiz "\n"
givenumber: .asciiz "Give 5-digit number in base "
cont: .asciiz " :\n"
str: .space 6
wrongnum: .asciiz "Wrong number; give again:\n"
decimal: .asciiz "Number in decimal is:\n"
exiting: .asciiz "\nEXIT"