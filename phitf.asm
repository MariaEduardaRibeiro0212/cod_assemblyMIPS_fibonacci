.data
    novalinha: .asciiz "\n"
    razaoaurea: .asciiz "Razao Aurea: \n"
    N30: .asciiz "\nTermo 30: \n"
    N40: .asciiz "\nTermo 40: \n"
    N41: .asciiz "\nTermo 41: \n"

.text
    main:
        # Inicializa os primeiros dois valores da sequência de Fibonacci
        li $t0, 0        # F0 = 0
        li $t1, 1        # F1 = 1

        # Imprime F0
        move $a0, $t0
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall

        # Imprime F1
        move $a0, $t1
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall

        # Calcula e imprime os próximos termos da sequência
        li $t2, 2        # Contador inicializa com 2
        li $t3, 42       # Teremos 41 termos

    loop:
        
        beq $t2, 31, salvar30   # Se contador igual a 30, salvar termo
        beq $t2, 41, salvar40   # Se contador igual a 41, salvar termo
        beq $t2, 42, salvar41   # Se contador igual a 42, salvar termo

        proximoTermo: # Calcula o próximo termo
        add $t4, $t0, $t1 # F(n) = F(n-1) + F(n-2)

        # Atualiza os valores de F(n-2) e F(n-1)
        move $t0, $t1
        move $t1, $t4

        # Imprime F(n)
        move $a0, $t4
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall

        # Incrementa o contador
        addi $t2, $t2, 1
        j loop
        
    salvar30:
        move $s1, $t4    # Salvar o N30  em $s1
        j proximoTermo

    salvar40:
        move $s2, $t4    # Salvar o N40  em $s2
        j proximoTermo

    salvar41:
        move $s3, $t4    # Salvar o N41  em $s3
        beq $t2, $t3, calculoRazao # Se contador igual 42, calcular razão aurea
        

    calculoRazao:
        # Calcular e imprimir a razão áurea
        li $v0, 4
        la $a0, razaoaurea
        syscall

        # Dividir o último termo pelo penúltimo
        move $a0, $t1
        move $a1, $t0
        jal printarFloat_da_divisao
        
        #Imprimir os termos 30, 40 e 41
imprimir:
   li $v0, 4       
        la $a0, N30   
        syscall
        move $a0, $s1
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall

        li $v0, 4        
        la $a0, N40   
        syscall
        move $a0, $s2
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall

        li $v0, 4       
        la $a0, N41   
        syscall
        move $a0, $s3
        jal printarInteiro
        li $v0, 4        
        la $a0, novalinha  
        syscall
        
        li $v0, 10       
        syscall


# Função para imprimir um inteiro
printarInteiro:
    li $v0, 1           
    syscall
    jr $ra             

# Função para dividir dois inteiros e imprimir o resultado como float
printarFloat_da_divisao:
    mtc1 $a0, $f12      # Move numerator para $f12
    mtc1 $a1, $f14      # Move denominator para $f14
    cvt.s.w $f12, $f12  # Converte numerator para float
    cvt.s.w $f14, $f14  # Converte denominator para float
    div.s $f12, $f12, $f14 # Divide $f12 por $f14
    mov.s $f0, $f12     # Move resultado para $f0
    li $v0, 2           
    syscall
    jr $ra