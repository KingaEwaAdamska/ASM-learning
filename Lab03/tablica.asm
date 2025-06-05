.data

RAM:                .space 4096  # Zakładam, że moja tablica nie przekroczy 4096 bajtów
wierszeText:        .asciiz "Podaj ilosc wierszy: "
kolumnyText:        .asciiz "Podaj ilosc kolumn: "
newline:            .asciiz "\n"
space:              .asciiz " "

.text

main:
# $s0 - ilość wierszy
# $s1 - ilość kolumn
# $s2 - początkowy adres tablicy
# $s3 - adres RAM

    # Wczytanie ilości wierszy: 
    li $v0, 4
    la $a0, wierszeText
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
    # Wczytanie ilości kolumn: 
    li $v0, 4
    la $a0, kolumnyText
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0
    
    # Zapisuję początkowy adres pierwszego poziomu tablicy:
    la $s3, RAM
    move $t0, $s3
    
    # Zapisuję początkowy adres drugiego poziomu tablicy:
    move $t2, $s3
    move $t1, $s0
    sll $t1, $t1, 4 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $s0, by uzyskać początek drugiego poziomu tablicy
    add $t2, $t2, $t1 # Teraz $t2 zawiera początkowy adres drugiego poziomu tablicy
    
    move $t1, $s1
    sll $t1, $t1, 4 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $t2, żeby przejść do następnej kolumny
    
    li $t3, 0
    mul $t4, $s1, 100 # Mnożenie wykonuje się tylko raz przez cały program
    
create_loop:
    bge $t3, $t4, end_create_loop
    move $t0, $t2 # Zapisuję adres $t2 jako następny adres kolumny
    sw $t3, ($t2) # Zapisuję do pierwszej komórki w kolumnie wartość
    
    addi $t3, $t3, 100 # Przechodzę do następnej wartości w pierwszej komórce w kolumnie
    addi $t0, $t0, 4 # Przechodzę do następnej komórki pierwszego poziomu
    add $t2, $t2, $t1 # Przechodzę do pierwszego adresu następnej kolumny
    j create_loop
    
end_create_loop:
