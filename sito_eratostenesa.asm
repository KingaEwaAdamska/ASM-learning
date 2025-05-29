.data

N: .word 100000 # stała n, ilość liczb
nprimes: .word 0
numall: .space 400004 # N * 4 + 4, żeby zapisać też 0
primes: .space 400004
sqrtN: .word 317 # wystarczy sprawdzić do i = 10
amntText: .asciiz "Ilosc liczb pierwszych: "
showText: .ascii "Liczby pierwsze: "
space: .asciiz " "
newline: .asciiz "\n"


.text
# $s0 - liczba N
# $s1 - adres tablicy
# $t0 - ilość miejsca do alokacji
# $t1 - iterator tablicy
# $t2 - aktualny adres
# $t3 - aktualna liczba

main:
    lw $s0, N
    la $s1, numall     # zapisanie adresu początku tablicy numall
    
    move $t2, $s1
    li $t3, 0
    
init_loop:
    bgt $t3, $s0, end_init	
    
    sw $t3, ($t2)
    
    addi $t3, $t3, 1   # przejście do następnej liczby
    addi $t2, $t2, 4   # przejście pod następny adres w tablicy
    j init_loop

end_init:

    li $t1, 1
    sll $t1, $t1, 2
    add $t1, $s1, $t1
    sw $zero, 0($t1)          # numall[1] = 0

##### tablica uzupełniona cyframi
# $s0 - liczba N
# $s1 - adres tablicy
# $s2 - sqrtN
# $t0 - iterator pierwszy - i
# $t1 - iterator drugi - j
# $t2 - aktualny adres
# $t3 - mnożenie i do aktualnego adresu

	lw $s2, sqrtN
    li $t0, 2          # iterację zaczynamy od 2
for_i:
    bgt $t0, $s2, sito_end # warunek pętli 1
    
    sll $t3, $t0, 2    # ustawienie adresu na i
    add $t2, $s1, $t3
    lw $t5, 0($t2)     # załaduj wartość z pamięci
    beq $t5, $zero, next_i # jeśli już wykreślona, pomiń
    
    move $t1, $t0      # j = i
    add $t1, $t1, $t0  # j = 2*i
for_j:
    bgt $t1, $s0, next_i # Warunek pętli 2
    
    sll $t3, $t1, 2    # ustawienie adresu na j
    add $t2, $s1, $t3  
    
    sw $zero, 0($t2)   # wyzerowanie pod danym adresem
    add $t1, $t1, $t0  # j += i
    j for_j            # skok do warunku pętli 2
    
next_i:
    addi $t0, $t0, 1   # i++
    j for_i

sito_end:

##### tablica zostawiła tylko liczby pierwsze, przepisanie do nowej tablicy:
# $s0 - liczba N
# $s1 - adres numall
# $s2 - sqrtN
# $t0 - aktualny adres numall
# $t1 - koncowy adres numall
# $t3 - aktualny adres primes
# $t4 - licznik liczb pierwszych

	la $t0, numall         # adres początku tablicy numall
    li $t5, 100001            # N + 1 elementów
    sll $t5, $t5, 2        # rozmiar w bajtach
    add $t1, $t0, $t5      # oblicz adres końca tablicy
    la $t3, primes         # adres docelowej tablicy primes
    li $t4, 0              # licznik liczb pierwszych
	
save_primes_loop:
	bge $t0, $t1, print_init 
	
	lw $t6, 0($t0)         # załaduj wartość z numall
    beqz $t6, skip_save    # jeśli 0 (nie pierwsza), pomiń
		sw $t6, 0($t3)
		addi $t3, $t3, 4
		addi $t4, $t4, 1
skip_save:
	addi $t0, $t0, 4
	j save_primes_loop

print_init:
	sw $t4, nprimes
	
	# Wydrukuj nagłówek
    li $v0, 4
    la $a0, amntText
    syscall
    
    # Wydrukuj ilość
    li $v0, 1
    lw $a0, nprimes
    syscall
    
    # Nowa linia
    li $v0, 4
    la $a0, newline
    syscall
	
    li $t1, 0          # iterator (i = 0)
    la $t2, primes

print_loop:
    bge $t1, $t4, end_print   # jeśli i > N, zakończ

    lw $a0, 0($t2)     # wczytaj liczbę z tablicy do $a0
    li $v0, 1          # kod syscall do print_int
    syscall

    # wypisz spację
    la $a0, space
    li $v0, 4          # kod syscall do print_string
    syscall

    addi $t2, $t2, 4   # przejdź do kolejnego elementu tablicy
    addi $t1, $t1, 1   # i++

    j print_loop

end_print:
    # zakończ program
    li $v0, 10
    syscall
