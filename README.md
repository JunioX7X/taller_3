# 📘 Taller 3 — Respuestas Técnicas

---

## 🔧 Parte 1 — Código en Ensamblador NASM

### 🧩 a) Desglose del Código

```asm
bits 64                  ; Modo 64 bits
default rel              ; Direccionamiento relativo por defecto

segment .data            ; Sección de datos inicializados
msg db "hola mundo!", 0x0D, 0x0A, 0  ; Cadena + CR + LF + NULL

segment .text            ; Sección de código ejecutable
global main              ; Punto de entrada visible externamente
extern ExitProcess       ; API de salida de Windows
extern printf            ; Función de impresión estándar

main:
    push rbp             ; Guardar marco anterior
    mov rbp, rsp         ; Crear nuevo marco de pila
    sub rsp, 32          ; Reservar espacio (shadow space)
    lea rcx, [msg]       ; Primer argumento para printf
    call printf          ; Imprimir mensaje
    xor rax, rax         ; Retorno 0
    call ExitProcess     ; Finalizar programa

⚙️ b) Ensamblado con NASM
bash
Copiar
Editar
nasm -fwin64 holamundo.asm
nasm: Ejecuta el ensamblador

-fwin64: Salida compatible con Windows x64

holamundo.asm: Archivo fuente

🛠️ Salida: holamundo.obj (código objeto sin enlaces)


🔗 c) Enlace con GCC
bash
Copiar
Editar
gcc -m64 holamundo.obj -o holamundo.exe
gcc: Enlazador y compilador de GNU

-m64: Target de 64 bits

holamundo.obj: Entrada generada por NASM

-o holamundo.exe: Salida ejecutable

🛠️ Dependencias resueltas automáticamente (msvcrt.dll, kernel32.dll)

🧰 d) Script de Compilación .bat (Windows)
bat

@echo off
if "%1"=="" (
    echo Uso: compilar [archivo_sin_extension]
    echo Ejemplo: compilar holamundo
    pause
    exit /b 1
)

echo Ensamblando %1.asm...
nasm -fwin64 %1.asm
if errorlevel 1 (
    echo Error en ensamblado
    pause
    exit /b 1
)

echo Enlazando %1.obj...
gcc -m64 %1.obj -o %1.exe
if errorlevel 1 (
    echo Error en enlace
    pause
    exit /b 1
)

echo EXE generado: %1.exe
pause



📌 Uso:

Guardar como: compilar.bat

Ejecutar: compilar nombre_archivo

Resultado: nombre_archivo.exe en la misma carpeta


💻 Parte 2 — Código en Lenguaje C
🧩 a) Estructura del Archivo holaenc.c


#include <conio.h>     // Entrada directa (getch)
#include <stdio.h>     // Entrada/salida (printf)

int main() {
    printf("Hola mundo.");
    getch();           // Espera una tecla (sin eco)
    return 0;
}



#include <conio.h>: Entrada directa (modo consola)

#include <stdio.h>: Funciones estándar

main: Punto de entrada

printf: Salida a consola

getch: Pausa ejecución

return 0: Finalización exitosa

🖥️ b) Ejecución del Programa Compilado (Paso 8)

📋 Proceso:

Carga de holaenc.exe por el sistema operativo

Ejecución de main()

Salida: "Hola mundo." en consola

getch(): Espera interacción del usuario

Retorno al shell al presionar una tecla

🧠 c) Desensamblado con ndisasm (Paso 9)

ndisasm holaenc.exe > holaenc.asm


📋 Análisis:

ndisasm: Desensamblador incluido con NASM

Entrada: holaenc.exe (binario compilado)

Salida: holaenc.asm (código ensamblador)

Objetivo:

Ver instrucciones generadas por el compilador

Inspeccionar llamadas a funciones estándar (printf, getch)

Analizar estructuras PE internas (Windows Portable Executable)
