.data

N: .word 15 # stała n, ilość liczb
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
    
    add $t1, $s0, 1    # uwzględnienie 0 w tablicy - ułatwienie operacji
    sll $t0, $t1, 2    # wyliczenie ilości potrzebnego miejsca na tablicę - 4 bajty na liczbę
    li $v0, 9
    move $a0, $t0
    syscall
    move $s1, $v0      # zapisanie adresu początku tablicy
    
    move $t2, $s1
    li $t3, 0
    
init_loop:
    bgt $t3, $s0, end_init	
    
    sw $t3, ($t2)
    
    addi $t3, $t3, 1   # przejście do następnej liczby
    addi $t2, $t2, 4   # przejście pod następny adres w tablicy
    j init_loop

end_init:

##### tablica uzupełniona cyframi
# $s0 - liczba N
# $s1 - adres tablicy
# $t0 - iterator pierwszy - i
# $t1 - iterator drugi - j
# $t2 - aktualny adres
# $t3 - mnożenie i do aktualnego adresu
# $t4 - ilość liczb pierwszych

    li $t4, 0          # licznik liczb pierwszych
    li $t0, 2          # iterację zaczynamy od 2
for_i:
    bgt $t0, $s0, sito_end # warunek pętli 1
    
    sll $t3, $t0, 2    # ustawienie adresu na i
    add $t2, $s1, $t3
    lw $t5, 0($t2)     # załaduj wartość z pamięci
    beq $t5, $zero, next_i # jeśli już wykreślona, pomiń
    
    addi $t4, $t4, 1   # inkrementacja licznika liczb pierwszych
    
    move $t1, $t0      # j = i
    add $t1, $t1, $t0  # j = 2*i
for_j:
    bgt $t1, $s0, next_i # Warunek pętli 2
    
    sll $t3, $t1, 2    # ustawienie adresu na j
    add $t2, $s1, $t3  # ustawienie adresu na j
    
    sw $zero, 0($t2)   # wyzerowanie pod danym adresem
    add $t1, $t1, $t0  # j += i
    j for_j            # skok do warunku pętli 2
    
next_i:
    addi $t0, $t0, 1   # i++
    j for_i

sito_end:

##### wyswietlenie ilosci liczb

    li $v0, 4
    la $a0, amntText
    syscall

    li $v0, 1
    move $a0, $t4
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall

##### tablica zostawiła tylko liczby pierwsze, przepisanie do nowej tablicy:
# $s0 - liczba N
# $s1 - adres tablicy 1
# $s2 - adres nowej tablicy
# $t0 - iterator pierwszy - i
# $t1 - iterator drugi - j
# $t2 - aktualny adres
# $t3 - mnożenie i do aktualnego adresu
# $t4 - ilość liczb pierwszych


print_init:

    li $t1, 0          # iterator (i = 0)
    move $t2, $s1      # $t2 - aktualny adres w tablicy

print_loop:
    bgt $t1, $s0, end_print   # jeśli i > N, zakończ

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