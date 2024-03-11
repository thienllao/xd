   section .data              ; сегмент инициализированных переменных
ExitMsg db "Press Enter to Exit",10  ; выводимое сообщение
lenExit equ $-ExitMsg
A dw -30
B dw 21

vall  db 255
shart dw 256
lue3  dw -128
v5 db 10h
   db 100101B
beta  db 23, 23h, 0ch
sdk   db "Hello", 10
min   dw -32767
ar dd 12345678h
valar times 5 db 8

value1   dw   25
value2   dd   -35
name     db   "Глеб Gleb"

val_2500 dw   37
val_0025 dw   9472

F1    dw    65535
F2    dd    65535

   section .bss               ; сегмент неинициализированных переменных
InBuf   resb    10            ; буфер для вводимой строки
lenIn   equ     $-InBuf

alu   resw  10
f1 resb  10

X  resd  1
        section .text         ; сегмент кода
        global  _start
_start:
        mov     eax, [A]       ; загрузить число А в регистр ЕАХ
        add     eax, 5        ; сложить ЕАХ и 5, результат в ЕАХ
        sub     eax, [B]       ; вычесть число В, результат в ЕАХ
        mov     [X] ,eax      ; Сохранить результат в памяти

        add    word[F1], 1
        add    dword[F2], 1
        ; write
        mov     rax, 1        ; системная функция 1 (write)
        mov     rdi, 1        ; дескриптор файла stdout=1
        mov     rsi, ExitMsg  ; адрес выводимой строки
        mov     rdx, lenExit  ; длина строки
        syscall               ; вызов системной функции
        ; read
        mov     rax, 0        ; системная функция 0 (read)
        mov     rdi, 0        ; дескриптор файла stdin=0
        mov     rsi, InBuf    ; адрес вводимой строки
        mov     rdx, lenIn    ; длина строки
        syscall               ; вызов системной функции
        ; exit
        mov     rax, 60       ; системная функция 60 (exit)
        xor     rdi, rdi      ; return code 0
        syscall               ; вызов системной функции
