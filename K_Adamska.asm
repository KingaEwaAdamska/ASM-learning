.data

N: .word 10000 # stała n, ilość liczb
nprimes: .word 0
numall: .space 40004 # N * 4 + 4, żeby zapisać też 0
primes: .space 400004
amntText: .asciiz "Ilosc liczb pierwszych: "
showText: .ascii "Liczby pierwsze: "
space: .asciiz " "
newline: .asciiz "\n"


.text
### Przypisanie rejestru do nazwy zmiennej z diagramu
# $s0 - N
# $t0 - numall
# $t1 - iterator

main:
    lw $s0, N
    la $t0, numall     # zapisanie adresu początku tablicy numall
    
    li $t1, 0
    
init_loop:
    bgt $t1, $s0, end_init	# i < N
    
    sw $t1, ($t0)	   # wpisanie do tablicy
    
    addi $t1, $t1, 1   # przejście do następnej liczby
    addi $t0, $t0, 4   # przejście pod następny adres w tablicy
    j init_loop

end_init:
	la $t0, numall
	addi $t0, $t0, 4
	sw $zero, ($t0) # jedynka nie jest liczbą pierwszą
	
### Przypisanie rejestru do nazwy zmiennej z diagramu
# $s0 - N

# $t0 - numall - act
	li $t4, 2
	sll $t4, $t4, 2
	la $t0, numall
	add $t0, $t0, $t4 # zaczynamy od 2
	
# $t1 - numall - last
	lw $t4, N
	subi $t4, $t4, 1 # korekcjka - zaczynam od drugiego indeksu
	sll $t4, $t4, 2
	add $t1, $t0, $t4
# $t2 - primes - act
	la $t2, primes
	
# $t3 - actPrimesCounter
	li $t3, 0
	
# Wyświetlenie komunikatu
	li $v0, 4
	la $a0, showText
	syscall

act_check_loop:
	bge $t0, $t1, end
	lw $t4, 0($t0)
	beqz $t4, next_val # numall[actCheck] == 0 - pomiń 
	
# zapisanie liczby pierwszej do tablicy primes
	sw $t4, ($t2)
	addi $t2, $t2, 4

# inkrementacja ilości liczb pierwszych
	addi $t3, $t3, 1
	
# Wyświetlenie liczby pierwszej
	li $v0, 1
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall

# Usunięcie wielokrotności liczby pierwszej
	mul $t5, $t4, $t4 # j = actCheck^2
	la $t6, numall
	sll $t7, $t5, 2 # o ile bitów przesuwać adres
	add $t6, $t6, $t7
	sll $t7, $t4, 2
	del_loop: # pętla usuwania wielokrotności z tablicy
		bgt $t6, $t1 next_val
		sw $zero, ($t6) # wyzerowanie wielokrotności
		add $t6, $t6, $t7 # przesunięcie do następnej wielokrotności actCheck
		j del_loop
next_val: 
	addi $t0, $t0, 4
    j act_check_loop
    
end:
	sw $t3, nprimes
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, amntText
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
    # zakończ program
    li $v0, 10
    syscall
