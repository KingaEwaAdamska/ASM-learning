#=============================================
.eqv STACK_SIZE 2048
#=============================================
.data
# obszar na zapamiętanie adresu stosu systemowego
sys_stack_addr: .word 0
# deklaracja własnego obszaru stosu
stack: .space STACK_SIZE
# deklaracja tablicy globalnej global_array
global_array:  . word 1,2,3,4,5,6,7,8,9,10
global_array_size: .word 10

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
 la $t0, global_aray 
 sw $t0, 4($sp)
 
	# zapisanie argumentu drugiego
	lw $t1, global_array_size
	sw $t1, ($sp)
 
 jal sum
 
 # koniec podprogramu main:
 lw $sp, sys_stack_addr # odtworzenie wskaźnika stosu
 # systemowego
 li $v0, 10
 syscall


sum:
	# alokacja miejsca na zwracaną wartość
	subi $sp, $sp, 4

	# alokacja miejsca na adres powrotu i zapis adresu powrotu
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	# alokacja miejsca na zmienne s oraz i przechowujące kolejno sumę i aktualnie sprawdzany element tablicy
	# adres i: $sp
	# adres s: $sp + 4

jr $ra