.data

RAM:                .space 4096  # Zakładam, że moja tablica nie przekroczy 4096 bajtów
wierszeText:        .asciiz "Podaj ilosc wierszy: "
kolumnyText:        .asciiz "Podaj ilosc kolumn: "
operacjaText: 		.asciiz "Wybierz operacje (o - odczyt, z - zapis, w - wyjscie): "
wierszText:         .asciiz "Podaj wiersz: "
kolumnaText:        .asciiz "Podaj kolumne: "
odczytText: 		.asciiz "Odczytana wartosc: "
zapisText: 			.asciiz "Wartosc do zapisania: "
newline:            .asciiz "\n"
space:              .asciiz " "

.text

main:
# $s0 - ilość wierszy
# $s1 - ilość kolumn
# $s2 - adres RAM

########## Wczytanie ilości wierszy #########
    li $v0, 4
    la $a0, wierszeText
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0
    
########## Wczytanie ilości kolumn #########
    li $v0, 4
    la $a0, kolumnyText
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0
    
########## Zapisanie pierwszego adresu pierwszego poziomu tablicy #########
    la $s2, RAM
    move $t0, $s2
    
########## Wyznaczenie rozpoczęcia drugiego poziomu tablicy #########
    move $t1, $s0
    sll $t1, $t1, 2 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $s0, by uzyskać początek drugiego poziomu tablicy
    add $t2, $s2, $t1 # Teraz $t2 zawiera początkowy adres drugiego poziomu tablicy
    
    move $t1, $s1
    sll $t1, $t1, 2 # Wyznaczam ilość bajtów, o którą muszę przesunąć adres $t2, żeby przejść do następnej kolumny
    
    li $t3, 0
    mul $t4, $s0, 100 # Mnożenie wykonuje się tylko raz przez cały program, pilnuje ilości wierszy by uniknąć dodatkowego licznika
    
create_loop:
    bge $t3, $t4, end_create_loop # Jeśli wartość dla 1 kolumny danego rzędu jest większa lub równa ilości rzędów ( * 100 ) zakończ tworzenie tablicy
    
    sw $t2, ($t0) # Zapisuję adres $t2 jako następny adres wiersza
    sw $t3, ($t2) # Zapisuję do pierwszej kolumny dla danego wiersza wartość
    

 ########## Wypełnienie pozostałych kolumn #########
    move $t5, $t3	# ustalam początkową wartość wypełniania wiersza
    add $t6, $t3, $s0 # ustalam wartość końcową wypełniania wiersza
    
    move $t7, $t2 # ustalam adres do wypełnienia kolumny
    
    
    fill_loop:
    	bge $t5, $t6, end_fill_loop # Jeśli wartość w $t3 jest większa lub równa niż i*100 + j wiersz jest wypełniony
    	
    	addi $t5, $t5, 1 # podnoszę wartość do wpisania o 1
    	addi $t7, $t7, 4 # przechodzę do następnej kolumny
    	
    	sw $t5, 0($t7) # zapisuję wartość
    	
    	j fill_loop
    end_fill_loop:
   
    
    addi $t3, $t3, 100 # Podnoszę wartość i*100 do następnego wiersza
    addi $t0, $t0, 4 # Przechodzę do następnej komórki pierwszego poziomu
    add $t2, $t2, $t1 # Przechodzę do adresu pierwszej kkolumny następnego wiersza
    j create_loop
    
end_create_loop:
# przechodzę do części z operacjami wybieranymi przez użytkownika
operation_loop:
########## Wybór operacji #########
	la $a0, newline
	li $v0, 4
	syscall

	la $a0, operacjaText
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	move $t0, $v0 # wczytanie znaku wprowadzonego przez użytkownika - UWAGA! nie czeka na zatwierdzenie Enter
	
	la $a0, newline
	li $v0, 4
	syscall
	
	beq $t0, 'w', end # wyjście jeśli wybrano w

########## Wybór wiersza #########
	la $a0, wierszText
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0 # wczytanie wiersza
	
########## Wybór kolumny #########
	la $a0, kolumnaText
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0 # wczytanie kolumny

########## Pobranie adresu potrzebnego do operacji #########
	sll $t3, $t1, 2 # wyznaczam ilość bajtów do przesunięcia by dotrzeć do dobrego adresu poziomu 1
	add $t4, $s2, $t3 # przechodzę pod odpowiedni adres, by być w dobrym wierszu
	
	lw $t5, ($t4)
	sll $t3, $t2, 2 # wyznaczam ilośc bajtów do przesunięcia aby dotrzeć do dobrzej kolumny
	add $t5, $t5, $t3
	
########## Przejście do operacji #########
	
	beq $t0, 'z', zapis
	beq $t0, 'o', odczyt
	
	j operation_loop # powrót do wyboru operacji, jeśli podano błędny znak
	

odczyt:
	# wyświetlanie 
	la $a0, odczytText
	li $v0, 4
	syscall
	
	li $v0, 1
	lw $a0, ($t5) # wyswietlenie wartosci
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall

	j operation_loop # powrót do wyboru operacji

zapis:
	# pobranie wartości podanej przez użytkownika
	la $a0, zapisText
	li $v0, 4
	syscall
	
	
	li $v0, 5
	syscall
	move $t6, $v0
	
	sw $t6, ($t5) # wpisanie wartości

	j operation_loop # powrót do wyboru operacji

end:

	li $v0, 10
	syscall