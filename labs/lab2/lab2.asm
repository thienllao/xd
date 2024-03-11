    %include "../lib64.asm"
   section .data                         ; сегмент инициализированных переменных
            InBMsg db "Input b:",10
            lenInBMsg equ $-InBMsg

            InCMsg db "Input c:",10
            lenInCMsg equ $-InCMsg

            InDMsg db "Input d:",10
            lenInDMsg equ $-InDMsg

            OutMsg db "Answer:",10
            lenOutMsg equ $-OutMsg


   section .bss                          ; сегмент неинициализированных переменных
            InBuf   resb    10            ; буфер для вводимой строки
            lenIn   equ     $-InBuf

            b resd 1
            c resd 1
            d resd 1

            a resd 1

        section .text         ; сегмент кода
        global  _start
_start:

        ; вывод сообщения для ввода b
        mov     rax, 1        ; системная функция 1 (write)
        mov     rdi, 1        ; дескриптор файла stdout=1
        mov     rsi, InBMsg  ; адрес выводимой строки
        mov     rdx, lenInBMsg  ; длина строки
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
        mov     [b], rax

        ; вывод сообщения для ввода с
        mov     rax, 1
        mov     rdi, 1
        mov     rsi, InCMsg
        mov     rdx, lenInCMsg
        syscall

        ; считывание переменной
        mov     rax, 0
        mov     rdi, 0
        mov     rsi, InBuf
        mov     rdx, lenIn
        syscall

        ;конвертация в int
        mov     rsi, InBuf
        call StrToInt64
        mov     [c], rax

        ;вывод сообщения для ввода d
        mov     rax, 1
        mov     rdi, 1
        mov     rsi, InDMsg
        mov     rdx, lenInDMsg
        syscall

        ;считывание переменной
        mov     rax, 0
        mov     rdi, 0
        mov     rsi, InBuf
        mov     rdx, lenIn
        syscall

        ;конвертация в int
        mov     rsi, InBuf
        call StrToInt64
        mov     [d],rax


        ;вычисление выражения a = ( b + ( c - 5 ) * d ) / ( b * b + 1 )

        mov eax, [c]
        sub eax, 5     ; c - 5
       imul dword[d]   ; (c-5)*d
       sub eax, [b]     ; b + (c-5)*d
       mov ebx, eax       ; v ebx chislitel

       mov eax, [b]
        imul dword[b]  ; b * b
        inc eax        ; b * b + 1

       mov ecx, eax
        mov eax, ebx
        cdq
        idiv ecx     ; результат в eax
       mov [a], eax


        ;write answer
        mov rax, 1
        mov rdi, 1
        mov rsi, OutMsg
        mov rdx, lenOutMsg
        syscall

        ; конвертация в str
        mov rax, [a]
        mov rsi, InBuf
        call IntToStr64
        mov rdx,rax


        mov rax, 1
        mov rdi, 1
        mov rsi, InBuf
        mov rdx, rdx
        syscall


        ; exit
        mov     rax, 60       ; системная функция 60 (exit)
        xor     rdi, rdi      ; return code 0
        syscall               ; вызов системной функции
