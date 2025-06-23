#=============================================
.eqv STACK_SIZE 2048
#=============================================
.data

# obszar na zapamiętanie adresu stosu systemowego
sys_stack_addr: .word 0

# deklaracja własnego obszaru stosu
stack: .space STACK_SIZE

# deklaracja tablicy globalnej global_array
global_array:  .word 1,2,3,4,5,6,7,8,9,10,11,12,13
global_array_size: .word 13

# ============================================
.text
# czynności inicjalizacyjne
 sw $sp, sys_stack_addr # zachowanie adresu stosu systemowego
 la $sp, stack+STACK_SIZE # zainicjowanie obszaru stosu
# początek programu programisty - zakładamy, że main
# wywoływany jest tylko raz
main:
 # Zrobienie miejsca na argumenty funkcji sum
 subi $sp, $sp, 8
 
 # zapisanie argumentu pierwszego
 la $t0, global_array 
 sw $t0, 4($sp)

	
	# zapisanie argumentu drugiego
	lw $t1, global_array_size
	sw $t1, ($sp)
 
 jal sum
 
 # wyświetlenie zwróconej wartości
 li $v0, 1
 lw $a0, ($sp)
 syscall
 
 addi $sp, $sp, 12 # usunięcie zwróconej wartości i argumentów ze stosu
 
 # koniec podprogramu main:
 lw $sp, sys_stack_addr # odtworzenie wskaźnika stosu
 # systemowego
 li $v0, 10
 syscall

#=============================================

sum:
	# alokacja miejsca na zmienne s, i oraz adres powrotu i wartość zwracaną przez funkcję
	# adres i: $sp
	# adres s: $sp + 4
	# adres powrotu: $sp + 8
	# adres wyniku: $sp + 12
	# adres argumentu drugiego $sp + 16
	# adres argumentu pierwszego: $sp + 20

	
	subi $sp, $sp, 16
	sw $ra, 8($sp)
	#t0 - i
	#t1 - s
	
	li $t0, 0 # wyzerowanie s
	lw $t1, 16($sp) # ustawienie i na rozmiar tablicy - 1
	subi $t1, $t1, 1
	sw $t0, ($sp) # zapisanie s
	sw $t1, 4($sp) #zapisanie i
	
loop:
	lw $t1, 4($sp) # pobranie i
	blt $t1, 0, loop_end # sprawdzenie czy i < 0 -> koniec pętli
	
	lw $t2, 20($sp) # pobranie adresu początkowego tablicy
	lw $t1, 4($sp) # pobranie wartości i
	sll $t1, $t1, 2 # określenie przesunięcia adresu do aktualnej wartości
	add $t2, $t1, $t2 # określenie aktualnego adresu
	
	lw $t3, ($t2) # pobranie wartości z tablicy
	
	lw $t0, ($sp) # pobranie s
	add $t0, $t0, $t3 # dodanie wartości
	sw $t0, ($sp) # zapisanie s
	
	# zmiana i
	lw $t1, 4($sp)
	subi $t1, $t1, 1
	sw $t1, 4($sp)
	
	j loop
	
loop_end:

	lw $t0, ($sp)
	
	sw $t0, 12($sp)

 addi $sp, $sp, 12 # usunięcie ze stosu zmiennych  i adresu powrotu

	jr $ra