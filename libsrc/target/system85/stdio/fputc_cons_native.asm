;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb (stdio interface)
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puart_tbr
        EXTERN  puart_usr

        PUBLIC  fputc_cons_native
        PUBLIC  _fputc_cons_native

;-------------------------------------------------------------------------
; Prints char and inserts CR ahead of LF, i.e. printf("\n") becomes "\r\n"
fputc_cons_native:
_fputc_cons_native:
        ld      de,sp+2         ;retreive the argument
        ld      a,(de)          ;from behind return addr
        ld      e,a             ;store char
        cp      0AH             ;linefeed (new line)?
        jp      nz,fputc1       ;it was not so print it
        ld      e,0DH           ;else insert carridge return
        call    fputc1          ;and print it first
        ld      e,0AH           ;then print linefeed
fputc1: in      a,(puart_usr)   ;uart status reg
        and     40H             ;tx data ready bit
        jp      z,fputc1        ;wait for ready
        ld      a,e             ;get char back
        out     (puart_tbr),a   ;write to uart
        ret
