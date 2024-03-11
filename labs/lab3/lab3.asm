        %include "../lib64.asm"
      section .data              ; сегмент инициализированных переменных
InAMsg db "Input a:",10  ; выводимое сообщение
lenInAMsg equ $-InAMsg

InBMsg db "Input b:",10
lenInBMsg equ $-InBMsg

InKMsg db "Input k (not zero):",10
lenInKMsg equ $-InKMsg

OutMsg db "Result f=",10
lenOutMsg equ $-OutMsg

   section .bss               ; сегмент неинициализированных переменных
InBuf   resb    10            ; буфер для вводимой строки
lenIn   equ     $-InBuf

a resd 1
b resd 1
k resd 1
f resd 1

        section .text         ; сегмент кода
        global  _start
_start:
    ; вывод сообщения для ввода k
        mov     rax, 1        ; системная функция 1 (write)
        mov     rdi, 1        ; дескриптор файла stdout=1
        mov     rsi, InKMsg  ; адрес выводимой строки
        mov     rdx, lenInKMsg  ; длина строки
        syscall               ; вызов системной функции

        ; считывание переменной
        mov     rax, 0        ; системная функция 0 (read)
        mov     rdi, 0        ; дескриптор файла stdin=0
        mov     rsi, InBuf    ; адрес вводимой строки
        mov     rdx, lenIn    ; длина строки
        syscall               ; вызов системной функции

        ; конвертация в int
        mov     rsi, InBuf
        call StrToInt64
        mov     [k], rax

        cmp dword[k], 0            ; если равно нулю, то ввод заново k
        je _start            ; если не равно нулю, то идем дальше

       ; вывод сообщения для ввода А
        mov rax, 1
        mov rdi, 1
        mov rsi, InAMsg
        mov rdx, lenInAMsg
        syscall

        ;считывание переменной

        mov     rax, 0        ; системная функция 0 (read)
        mov     rdi, 0        ; дескриптор файла stdin=0
        mov     rsi, InBuf    ; адрес вводимой строки
        mov     rdx, lenIn    ; длина строки
        syscall               ; вызов системной функции

       ;конвертация в Int
        mov rsi, InBuf
        call StrToInt64
        mov [a], rax

              ; вывод сообщения для ввода b
        mov rax, 1
        mov rdi, 1
        mov rsi, InBMsg
        mov rdx, lenInBMsg
        syscall

        ;считывание переменной

        mov     rax, 0        ; системная функция 0 (read)
        mov     rdi, 0        ; дескриптор файла stdin=0
        mov     rsi, InBuf    ; адрес вводимой строки
        mov     rdx, lenIn    ; длина строки
        syscall               ; вызов системной функции

       ;конвертация в Int
        mov rsi, InBuf
        call StrToInt64
        mov [b], rax


        ; calculate
        mov      rax, [a]
        add     rax, [b]   ; a + b в регистре eax
        cmp     rax, 0
        ;mov [f], rax
        jg result

        mov rax , [a]
        imul dword[b]
        cdq
        idiv dword[k]
        mov [f], eax
        jmp result

result:
        mov [f], rax

        mov rax, 1
        mov rdi, 1
        mov rsi, OutMsg
        mov rdx, lenOutMsg
        syscall

        mov rax, [f]
        mov rsi, InBuf
        call IntToStr64
        mov rdx,rax
        ;mov [f], rax

        mov rax, 1
        mov rdi, 1
        mov rsi, InBuf;rsi
        mov rdx, rdx
        syscall

; двойной вывод мусора надо пофиксить


       ; exit
        mov     rax, 60       ; системная функция 60 (exit)
        xor     rdi, rdi      ; return code 0
        syscall               ; вызов системной функции
