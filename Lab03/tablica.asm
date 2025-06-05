.data

RAM:                .space 4096  # Zakładam, że moja tablica nie przekroczy 4096 bajtów
wierszeText:        .asciiz "Podaj ilosc wierszy: "
kolumnyText:        .asciiz "Podaj ilosc kolumn: "
operacjaText: 		.asciiz "Wybierz operacje (o - odczyt, z - zapis, w - wyjscie): "
wierszText:        .asciiz "Podaj wiersz: "
kolumnaText:        .asciiz "Podaj kolumne: "
odczytText: 		.asciiz "Odczytana wartosc: "
zapisText: 			.asciiz "Wartość do zapisania: "
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
    move $t1, $s0
    sll $t1, $t1, 2 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $s0, by uzyskać początek drugiego poziomu tablicy
    add $t2, $s3, $t1 # Teraz $t2 zawiera początkowy adres drugiego poziomu tablicy
    
    move $t1, $s1
    sll $t1, $t1, 2 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $t2, żeby przejść do następnej kolumny
    
    li $t3, 0
    mul $t4, $s0, 100 # Mnożenie wykonuje się tylko raz przez cały program
    
create_loop:
    bge $t3, $t4, end_create_loop
    
    sw $t2, ($t0) # Zapisuję adres $t2 jako następny adres kolumny
    sw $t3, ($t2) # Zapisuję do pierwszej komórki w kolumnie wartość
    
    # $t3 - wielokrotność setki
    # $t2 - adre pierwszej kolumny
    # $t4 - wartość do wpisania do kolumn
    # $t5 - wartość kończąca wewnętrzną pętlę
    
    move $t5, $t3
    add $t6, $t3, $s0 # ustalam wartość końcową wypełniania kolumny
    
    move $t7, $t2 # ustalam adres do wypełnienia kolumny
    
    
    fill_loop:
    	bge $t5, $t6, end_fill_loop
    	
    	addi $t5, $t5, 1
    	addi $t7, $t7, 4
    	
    	sw $t5, 0($t7)
    	
    	j fill_loop
    end_fill_loop:
   
    
    addi $t3, $t3, 100 # Przechodzę do następnej wartości w pierwszej komórce w kolumnie
    addi $t0, $t0, 4 # Przechodzę do następnej komórki pierwszego poziomu
    add $t2, $t2, $t1 # Przechodzę do pierwszego adresu następnej kolumny
    j create_loop
    
end_create_loop:

user_loop:
########## Wybór operacji #########
	la $a0, operacjaText
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	
	move $t0, $v0
	
	la $a0, newline
	li $v0, 4
	syscall
	
	beq $t0, 'w', end_user_loop

########## Wybór wiersza #########
	la $a0, wierszText
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0
	
########## Wybór kolumny #########
	la $a0, kolumnaText
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0

########## Wykonanie operacji #########
	sll $t3, $t1, 2 # wyznaczam ilość bajtów do przesunięcia by dotrzeć do dobrego adresu poziomu 1
	add $t4, $s3, $t3 # przechodzę pod odpowiedni adres, by być w dobrym wierszu
	
	lw $t5, ($t4)
	sll $t3, $t2, 2 # wyznaczam ilośc bajtów do przesunięcia aby dotrzeć do dobrzej kolumny
	add $t5, $t5, $t3
	
	beq $t0, 'z', zapis
	beq $t0, 'o', odczyt
	
	la $a0, newline
	li $v0, 4
	syscall
	
	j user_loop
	

odczyt:
	
	la $a0, odczytText
	li $v0, 4
	syscall
	
	li $v0, 1
	lw $a0, ($t5)
	syscall
	
	move $t2, $v0
	
	la $a0, newline
	li $v0, 4
	syscall

	j user_loop

zapis:

	la $a0, zapisText
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t6, $v0
	
	sw $t6, ($t5)

	j user_loop


end_user_loop:

# WYSWIETLANIE PEŁNEJ TABLICY
move $t0, $s3        # wskaźnik do tablicy wskaźników (poziom 1)
li $t5, 0            # indeks wiersza

outer_loop:
    bge $t5, $s0, end_loop

    lw $t1, ($t0)     # wczytaj wskaźnik do tablicy kolumn (wiersz)
    li $t6, 0         # indeks kolumny

    inner_loop:
        bge $t6, $s1, end_inner_loop

        lw $a0, ($t1)
        li $v0, 1
        syscall

        li $v0, 4
        la $a0, space
        syscall

        addi $t1, $t1, 4
        addi $t6, $t6, 1
        j inner_loop
    end_inner_loop:

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 4
    addi $t5, $t5, 1
    j outer_loop
end_loop:
