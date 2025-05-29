.data

N: .word 10000 # stała n, ilość liczb
nprimes: .word 0
numall: .space 40004 # N * 4 + 4, żeby zapisać też 0
primes: .space 40004
amntText: .asciiz "Ilosc liczb pierwszych: "
showText: .ascii "Liczby pierwsze: "
space: .asciiz " "
newline: .asciiz "\n"
timeText: .asciiz "\nCzas wykonania: "
msText: .asciiz " ms\n"

.text
main:
    # Początek pomiaru czasu
    li $v0, 30        # syscall get time in milliseconds
    syscall
    move $t8, $a0     # zapisz czas startu w $t8

    lw $s0, N
    la $t0, numall     # zapisanie adresu początku tablicy numall
    
    li $t1, 0
    
init_loop:
    bgt $t1, $s0, end_init
    
    sw $t1, ($t0)
    
    addi $t1, $t1, 1
    addi $t0, $t0, 4
    j init_loop

end_init:
    la $t0, numall
    addi $t0, $t0, 4
    sw $zero, ($t0)

    li $t4, 2
    sll $t4, $t4, 2
    la $t0, numall
    add $t0, $t0, $t4
    
    lw $t4, N
    subi $t4, $t4, 1
    sll $t4, $t4, 2
    add $t1, $t0, $t4
    
    la $t2, primes
    li $t3, 0
    
    li $v0, 4
    la $a0, showText
    syscall

act_check_loop:
    bge $t0, $t1, end
    lw $t4, 0($t0)
    beqz $t4, next_val
    
    sw $t4, ($t2)
    addi $t2, $t2, 4
    addi $t3, $t3, 1
    
    li $v0, 1
    move $a0, $t4
    syscall
    
    li $v0, 4
    la $a0, space
    syscall

    mul $t5, $t4, $t4
    la $t6, numall
    sll $t7, $t5, 2
    add $t6, $t6, $t7
    sll $t7, $t4, 2
del_loop:
    bgt $t6, $t1, next_val
    sw $zero, ($t6)
    add $t6, $t6, $t7
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

    # Koniec pomiaru czasu i wyświetlenie wyniku
    li $v0, 30        # syscall get time in milliseconds
    syscall
    sub $a0, $a0, $t8 # oblicz różnicę czasu
    
    li $v0, 4
    la $a0, timeText
    syscall
    
    li $v0, 1
    move $a0, $a0     # wyświetl czas wykonania
    syscall
    
    li $v0, 4
    la $a0, msText
    syscall
    
    li $v0, 10
    syscall