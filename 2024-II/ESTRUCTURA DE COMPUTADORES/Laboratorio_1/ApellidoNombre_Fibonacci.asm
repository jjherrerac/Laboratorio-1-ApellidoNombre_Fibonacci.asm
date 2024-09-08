# ApellidoNombre_Fibonacci.asm
# Este programa genera la serie Fibonacci según la cantidad de números ingresados por el usuario.
# Luego imprime los números de la serie y la suma total de los mismos.

.data
    prompt_num:    .asciiz "¿Cuántos números de la serie Fibonacci desea generar? "
    result_msg:    .asciiz "La serie Fibonacci es: "
    sum_msg:       .asciiz "La suma de la serie es: "
    newline:       .asciiz "\n"

    .align 2                       # Alineación de 4 bytes para evitar errores
    fib_series:    .space 20        # Espacio para almacenar hasta 5 números de Fibonacci (5 * 4 bytes)
    count:         .word 0          # Cantidad de números que el usuario quiere generar
    sum:           .word 0          # Variable para almacenar la suma de la serie

.text
.globl main

main:
    # Pedir al usuario cuántos números de la serie Fibonacci quiere generar
    li $v0, 4                    # Código de syscall para imprimir cadena
    la $a0, prompt_num            # Cargar el mensaje a mostrar
    syscall                       # Imprimir mensaje

    li $v0, 5                    # Código de syscall para leer entero
    syscall                       # Leer cantidad de números
    move $t0, $v0                # Guardar la cantidad en $t0
    sw $t0, count                # Guardar el número ingresado en memoria

    # Verificar que el número sea mayor que 0
    blez $t0, end                # Si es menor o igual a 0, salir del programa

    # Inicializar los primeros valores de la serie Fibonacci
    li $t1, 0                    # fib_0 = 0
    li $t2, 1                    # fib_1 = 1
    li $t3, 0                    # Contador para la serie

    # Iniciar la suma
    sw $t1, sum                  # Iniciar la suma con el primer número (0)
    la $t4, fib_series           # Cargar la dirección base del array fib_series

fibonacci_loop:
    bge $t3, $t0, print_result   # Si hemos generado suficientes números, mostrar resultado

    # Guardar el número de Fibonacci actual en la serie
    beq $t3, 0, first_num        # Si es el primer número, guardar 0
    beq $t3, 1, second_num       # Si es el segundo número, guardar 1

    # Calcular el siguiente número de Fibonacci
    add $t5, $t1, $t2            # fib_n = fib_(n-1) + fib_(n-2)
    sw $t5, 0($t4)               # Guardar el número en el array
    add $t1, $t2, $zero          # fib_(n-2) = fib_(n-1)
    add $t2, $t5, $zero          # fib_(n-1) = fib_n

    # Sumar el número a la suma total
    lw $t6, sum
    add $t6, $t6, $t5            # sum += fib_n
    sw $t6, sum

    j next_fib                   # Saltar al siguiente número

first_num:
    sw $t1, 0($t4)               # Guardar 0 en la serie
    j next_fib

second_num:
    sw $t2, 0($t4)               # Guardar 1 en la serie
    lw $t6, sum
    add $t6, $t6, $t2            # Sumar 1 a la suma total
    sw $t6, sum

next_fib:
    addi $t4, $t4, 4             # Mover a la siguiente posición del array
    addi $t3, $t3, 1             # Incrementar el contador
    j fibonacci_loop             # Repetir el bucle

# Mostrar los resultados
print_result:
    # Imprimir mensaje de la serie
    li $v0, 4
    la $a0, result_msg
    syscall

    # Imprimir la serie de Fibonacci
    la $t4, fib_series           # Cargar la dirección base del array
    li $t3, 0                    # Reiniciar el contador

print_loop:
    bge $t3, $t0, print_sum      # Si se imprimen todos los números, salir del bucle

    lw $a0, 0($t4)               # Cargar el número actual de la serie
    li $v0, 1                    # Código de syscall para imprimir entero
    syscall

    li $v0, 4                    # Imprimir una nueva línea
    la $a0, newline
    syscall

    addi $t4, $t4, 4             # Mover a la siguiente posición
    addi $t3, $t3, 1             # Incrementar el contador
    j print_loop                 # Repetir para el siguiente número

# Imprimir la suma de la serie
print_sum:
    li $v0, 4
    la $a0, sum_msg
    syscall

    lw $a0, sum                  # Cargar la suma
    li $v0, 1                    # Código de syscall para imprimir entero
    syscall

    # Imprimir nueva línea
    li $v0, 4
    la $a0, newline
    syscall

end:
    li $v0, 10                   # Código de syscall para salir del programa
    syscall
