.data

result:  	.word 0	  # wynik
overflow_msg:   .asciiz "Result overflowed"
prompt1:        .asciiz "Enter multiplicand: "
prompt2:        .asciiz "Enter multiplier:   "


.text
# $t0 - mnożna
# $t1 - mnożnik
# $t2 - wynik
# $t3 - bufor dla ostatniej cyfry mnożnika

main:
	# wyświetlenie prompt1 - prośy o mnożną
	li $v0, 4
	la $a0, prompt1
	syscall

	# odczyt mnożnej
	li $v0, 5
	syscall
	move $t0, $v0  # wczytanie mnożnej do rejestru

	# wyświetlenie prompt2 - prośy o mnożnik
	li $v0, 4
	la $a0, prompt2
	syscall

	# odczyt mnożnika
	li $v0, 5
	syscall
	move $t1, $v0  # wczytanie mnożnika do rejestru
	
	# inicjalizacja rejetru wyniku
	li $t2, 0
	
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
