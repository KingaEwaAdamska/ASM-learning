.data
coefs:       .float 2, 3.43, 4, 5.13
degree:      .word 3
enterText:   .asciiz "Podaj X do wyliczenia wartosci wielomianu: "
resultText:  .asciiz "Wartosc wielomianu dla podanego x to: "
newLine:     .asciiz "\n"

.text
.globl main

main:
enter_loop:
    # Wypisz komunikat
    la $a0, enterText
    li $v0, 4
    syscall

    # Wczytaj x (single)
    li $v0, 6
    syscall
    mov.s $f12, $f0           # x jako float
    cvt.d.s $f12, $f12        # konwersja do double (x -> $f12:$f13)

    la $a0, coefs             # adres współczynników
    lw $a1, degree            # stopień wielomianu
    jal eval_poly             # wywołanie funkcji

    # Wyświetl wynik
    la $a0, resultText
    li $v0, 4
    syscall

    # Konwersja double -> single (wynik z $f0:$f1 do $f12)
    cvt.s.d $f12, $f0
    mov.s $f12, $f12

    li $v0, 2
    syscall

    # Nowa linia
    la $a0, newLine
    li $v0, 4
    syscall

    j enter_loop

#====================================
# Funkcja eval_poly
# Argumenty:
# $a0 - adres tablicy współczynników (float), uporządkowane od najwyższego stopnia do 0
# $a1 - stopień wielomianu (int)
# $f12:$f13 - wartość x (double)
# Zwraca:
# $f0
eval_poly:
    # Ustaw licznik pętli i wskaźnik na pierwszy współczynnik
    move $t3, $zero           # i = 0
    move $t5, $a0             # wskaźnik na coefs[i]

    # Wczytaj pierwszy współczynnik (najwyższy stopień)
    lwc1 $f4, 0($t5)
    cvt.d.s $f0, $f4          # wynik = coefs[0]

    eval_loop:
        addi $t3, $t3, 1
        bgt $t3, $a1, end_eval_loop

        addi $t5, $t5, 4      # przesunięcie na kolejny współczynnik
        lwc1 $f4, 0($t5)
        cvt.d.s $f6, $f4      # $f6 = coefs[i] (double)

        # Horner: wynik = wynik * x + coefs[i]
        mul.d $f0, $f0, $f12
        add.d $f0, $f0, $f6

        j eval_loop

end_eval_loop:
    jr $ra
