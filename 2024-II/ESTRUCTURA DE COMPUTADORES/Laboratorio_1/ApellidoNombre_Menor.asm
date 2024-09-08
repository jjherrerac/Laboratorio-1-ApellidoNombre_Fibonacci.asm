# ApellidoNombre_Menor.asm
# Este programa permite al usuario ingresar entre 3 y 5 números y determina cuál es el menor.
# Cada instrucción está comentada para facilitar la comprensión.

.data
    prompt_num:      .asciiz "Ingrese un número: "
    prompt_count:    .asciiz "¿Cuántos números desea comparar (mínimo 3, máximo 5)? "
    result_msg:      .asciiz "El menor número es: "
    newline:         .asciiz "\n"

    nums:            .word 0, 0, 0, 0, 0    # Arreglo para almacenar hasta 5 números
    count:           .word 0                # Cantidad de números a comparar
    min_num:         .word 0                # Variable para almacenar el número menor

.text
.globl main

main:
    # Solicitar al usuario cuántos números quiere ingresar
    li $v0, 4                # Código de syscall para imprimir cadena
    la $a0, prompt_count      # Cargar la dirección del mensaje
    syscall                  # Imprimir mensaje

    li $v0, 5                # Código de syscall para leer entero
    syscall                  # Leer cantidad de números
    move $t0, $v0            # Guardar la cantidad en $t0

    # Verificar que el número sea entre 3 y 5
    li $t1, 3                # Valor mínimo de números
    li $t2, 5                # Valor máximo de números
    blt $t0, $t1, end        # Si es menor que 3, terminar el programa
    bgt $t0, $t2, end        # Si es mayor que 5, terminar el programa

    # Almacenar la cantidad de números
    sw $t0, count

    # Iniciar bucle para leer los números
    li $t3, 0                # Contador para el número de entradas
    la $t4, nums             # Cargar la dirección base del array nums

input_loop:
    bge $t3, $t0, find_min   # Si se han ingresado todos los números, salir del bucle

    # Imprimir mensaje para ingresar un número
    li $v0, 4
    la $a0, prompt_num
    syscall

    # Leer el número ingresado
    li $v0, 5
    syscall
    sw $v0, 0($t4)           # Almacenar el número en el array nums
    addi $t4, $t4, 4         # Incrementar la dirección para el siguiente número

    addi $t3, $t3, 1         # Incrementar el contador de entradas
    j input_loop             # Volver al inicio del bucle

# Encontrar el número menor
find_min:
    la $t4, nums             # Cargar la dirección base del array nums
    lw $t5, 0($t4)           # Cargar el primer número
    sw $t5, min_num          # Guardar el primer número como mínimo inicial

    li $t3, 1                # Contador para comparar el resto de los números
    addi $t4, $t4, 4         # Mover la dirección al siguiente número

min_loop:
    bge $t3, $t0, display_result   # Si se han comparado todos los números, mostrar el resultado

    lw $t6, 0($t4)           # Cargar el siguiente número
    lw $t7, min_num          # Cargar el número menor actual
    bge $t6, $t7, skip       # Si el número actual es mayor o igual, omitir

    sw $t6, min_num          # Si el número actual es menor, guardarlo como mínimo

skip:
    addi $t4, $t4, 4         # Mover la dirección al siguiente número
    addi $t3, $t3, 1         # Incrementar el contador
    j min_loop               # Repetir el bucle

# Mostrar el resultado
display_result:
    li $v0, 4
    la $a0, result_msg
    syscall

    lw $a0, min_num          # Cargar el número menor
    li $v0, 1                # Código de syscall para imprimir entero
    syscall

    # Imprimir nueva línea
    li $v0, 4
    la $a0, newline
    syscall

end:
    li $v0, 10               # Código de syscall para salir del programa
    syscall
