.data

l1: 		.word 5 # mnożna
l2: 		.word 2 # mnożnik
result:  	.word 0	  # wynik
overflow_msg:   .asciiz "Result overflowed"


.text
main:
	# wczytanie liczb
	lw $t0, l1
	lw $t1, l2
	
	li $t2, 0 # wynik
	li $t3, 0 # sprawdzenie ostatniej cyfry
	
loop:
	beqz $t1, end # jeśli mnożnik = 0 - zakoncz
	and $t3, $t1, 1 # pobranie ostatniej cyfry mnożnika
	beqz $t3, skip # jesli ostatnia cyfra mnożnika 0 - idź dalej 
	
	addu $t4, $t0, $t2 # do dodatkowego rejestru dodajemy wynik
	blt $t4, $t2, overflow
	move $t2, $t4
	
skip:
	sll $t0, $t0, 1
	srl $t1, $t1, 1
	j loop
end:
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 10
	syscall

overflow:
	li $v0, 4
	la $a0, overflow_msg
	syscall
	
	li $v0, 10
	syscall