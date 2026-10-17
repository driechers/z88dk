;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puart_tbr
        EXTERN  puart_usr

        PUBLIC  _uart_puts

;-------------------------------------------------------------------------
; extern void uart_puts(uint8 *pData);
_uart_puts:
        ld      de,sp+2         ;retreive the argument (ptr)
        ld      hl,(de)         ;from behind the ret addr
puts1:  ld      a,(hl)          ;get next char in string
        or      a               ;test if zero
        ret     z               ;quit on null
        ld      b,a             ;temporary storage
puts2:  in      a,(puart_usr)   ;uart status reg
        and     40H             ;tx data ready bit
        jp      z,puts2         ;wait for ready
        ld      a,b             ;get char back
        out     (puart_tbr),a   ;uart data reg
        inc     hl              ;bump pointer
        jp      puts1

