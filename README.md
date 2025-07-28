Parte 1: Implementación en Ensamblador NASM para Arquitectura x86-64
a. Descomposición Semántica del Código Ensamblador


bits 64
default rel
segment .data
    msg db "hola mundo!", 0xd, 0xa, 0
segment .text
global main
extern ExitProcess
extern printf
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rcx, [msg]
    call printf
    xor rax, rax
    call ExitProcess

    Instrucción/Directiva	Propósito Técnico
bits 64	Especifica modo de direccionamiento para arquitectura AMD64
default rel	Habilita direccionamiento relativo para posición independiente (PIC)
segment .data	Delimita segmento de datos inicializados
msg db ...	Reserva espacio en memoria para cadena ASCIIZ con secuencias de control CR/LF
segment .text	Define segmento de código ejecutable
global main	Exporta símbolo main para resolución de enlazador
extern ExitProcess	Declara dependencia externa de la API Win32 (kernel32.dll)
extern printf	Declara dependencia de función CRT (msvcrt.dll)
push rbp	Preserva puntero de marco base en pila
mov rbp, rsp	Establece nuevo marco de pila (stack frame)
sub rsp, 32	Reserva shadow space (32 bytes) conforme convención calling x64
lea rcx, [msg]	Carga dirección efectiva del mensaje en registro parámetro RCX
call printf	Invoca función de biblioteca C mediante tabla de importación (IAT)
xor rax, rax	Establece registro de retorno a cero (exit code SUCCESS)
call ExitProcess	Termina proceso mediante llamada al sistema Windows API

b. Proceso de Ensamblado con NASM

nasm -fwin64 holamundo.asm

Propósito: Traducción de código fuente a objeto relocalizable

Parámetro -fwin64: Especifica formato COFF/PE para sistemas Win64

Salida: Genera archivo objeto (holamundo.obj) con:

Código máquina en sección .text

Símbolos exportados/importados

Datos inicializados en sección .data

Información de relocalización

c. Proceso de Enlazado con GCC

gcc -m64 holamundo.obj -o holamundo.exe


Componente	Función
gcc (frontend)	Invoca enlazador (ld) con configuración específica para Windows
-m64	Forza modo de 64 bits en todas las etapas
holamundo.obj	Proporciona símbolos exportados y requerimientos de importación
-o holamundo.exe	Especifica nombre del ejecutable portable (PE32+ format)
Resolución	Vincula con bibliotecas CRT y kernel32.dll mediante tablas de importación (IAT)


d. Automatización mediante Script Batch


@echo off
if "%1"=="" (
    echo Sintaxis: compilar [nombre_archivo_sin_extension]
    echo Ejemplo: compilar programa
    exit /b 1
)

nasm -fwin64 %1.asm || goto :error
gcc -m64 %1.obj -o %1.exe || goto :error

echo Compilacion exitosa: %1.exe
exit /b 0

:error
echo Error en etapa de compilacion
exit /b 1

Características de Implementación:

Validación de parámetros obligatorios

Manejo de errores por etapas con errorlevel

Sintaxis POSIX-compatible (|| operador)

Mensajes de estado contextualizados

Retorno de códigos de error estándar

Parte 2: Análisis de Binario Compilado desde C
a. Estructura del Programa holaenc.c



#include <conio.h>  // Funciones de consola específicas
#include <stdio.h>  // E/S estándar

int main() {
    printf("Hola mundo.");  // Salida formateada
    getch();                // Espera entrada silenciosa
    return 0;               // Exit code SUCCESS
}


Elemento	Función Técnica
#include <conio.h>	Provee acceso a getch() (no estándar)
printf()	Implementa buffering de salida mediante stdout
getch()	Lee carácter directamente de teclado sin eco (unbuffered input)
return 0	Cumple con convención de retorno de proceso ISO C



> holaenc.exe


Fases de Ejecución:

Carga de Dependencias:

Resolución de IAT (msvcrt.dll, kernel32.dll)

Inicialización de CRT (tabla de vectores)

Flujo de Programa:

printf: Escribe en buffer de salida (stdout)

fflush(stdout): Implícito al llamar getch()

getch: Bloquea ejecución esperando scancode

Terminación Controlada:

Liberación de recursos manejadores

Retorno al SO con código 0 (ExitProcess)

c. Ingeniería Inversa con NDISASM


ndisasm -b 64 holaenc.exe > holaenc.asm




Aspectos Revelados en el Desensamblado:

Cabecera PE:

Punto de entrada real (≠ main)

Secciones ejecutables (.text)

Código de Inicialización CRT:

Setup de entorno

Registro de handlers

Llamadas a Sistema:

WriteFile (implementación de printf)

ReadConsoleInput (implementación de getch)

Offsets de Memoria:

Direcciones relativas (RIP-relative)

Tablas de saltos (jump tables)

Limitaciones del Desensamblado:

Pérdida de metadatos de símbolos

Dificultad para reconstruir estructuras de control

Código de bibliotecas sin diferenciar
