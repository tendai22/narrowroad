/*
 * dict.s ... generated (intermediate) code for building a Forth dictionary
 */

.include "emu68kplus.h"

    .equ    code_top, 0x1000
    .equ    ram_end, 0x10000

/*
 * code segment
 */
    .org    code_top
/*
 * memory map
 *
 * ram_top
 * code_top +-----------------
 *          | 4096byte max
 *          |
 * dict_top +-----------------
 *          | 4096byte max
 *          |
 *          +-----------------
 * linbuf   +-----------------
 *          |   64 byte
 *          +-----------------
 *
 *          +-----------------
 *          |  128 entry (256byte)
 *  dsp_end +-----------------
 *          |  128 entry (256byte)
 *  rsp_end +-----------------
 *          |  1024byte
 *          |
 *  sp_end  +-----------------
 *  ram_end 
 */
    .equ    code_top,  ram_top
    .equ    dict,  code_top + 0x1000
    .equ    linbuf,    dict_top + 0x1000

    .equ    sp_end,     ram_end
    .equ    end_sp,     sp_end
    .equ    rsp_end,    sp_end - 256
    .equ    end_rsp,    rsp_end
    .equ    dsp_end,    rsp_end - 256

/*
 * Forth interpreter initialize
 */
start:
/* virtual Forth machine registers */
    |.define IP a6
    |.define SP a5
    |.define RP a4
    move.l   #end_ram,%a7       /* set stack pointer */
    move.l   #end_sp,%a5        /* set SP */
    move.l   #end_rsp,%a4       /* set RSP */
    /* IP should be set later */
    move.l   #test_do_list,%a6  /* initialize IP */
    bra.b    do_next
/*
 * strings
 */

halt_message:
    dc.b    4
    .string  "halt"
    .align 2
/*
 * do_system ... halt the interpreter
 */
do_system:
    move.l   #halt_message,%a0
    jsr      (putstr)
do_system0:
    bra.b    do_system0         /* infinite loop
  
/*
 *  putch ... put one char from %d0
 */
putch:
    move.w    %d0,-(%a7)          /*  push %d0 */
putch1:
    move.b  (uart_creg),%d0
    and.b   #u3txif,%d0
    beq.b    putch1
    /*  now TXBUF be ready */
    move.w     (%a7)+,%d0         /*  pop %d0 */
    move.b  %d0,(uart_dreg)
    rts
/*
 * getch ... get one char in %d0
 */
getch:
    move.b (uart_creg),%d0
    and.b  #u3rxif,%d0
    beq.b  getch
    /* now RXRDY */
    move.b  (uart_dreg),%d0
    rts
/*
 * putstr
 * in: %a0: buf[0] ... n,length, buf[1]..[n] body of str
 */
putstr:
    move.w  %a0,-(%sp)      /* push %a0 */
    move.w  %d1,-(%sp)      /* push %d1 */
    move.w  %d0,-(%sp)      /* push %d0 */
    move.w  (%a0)+,%d1      /* use %d1 as counter */
putstrl:
    add.w   #-1,%d1          /* --%d1 */
    blt     putstre
    move.b  (%a0)+,%d0
    jsr     (putch)
    bra.b   putstrl
putstre:
    move.w  (%sp)+,%d0
    move.w  (%sp)+,%d1
    move.w  (%sp)+,%a0
    rts
/*
 * inner interpreter 
 */
do_list:
    move.w  %a6,-(%a4)          /* push IP */
    add.w   #2,%a6              /* IP points the first token address */
    bra.b   do_next
do_exit:
    move.w  (%a4)+,%a6
    bra.b   do_next
    nop
do_next:
    move.w  (%a6)+,%a0
    jmp     %a0             /* exec next token */
/* virtual machine instruction */
do_lit:
    move.w  (%a6)+,%d0
    move.w   %d0,-(%a5)
    bra.b   do_next
/* do_add */
do_add:
    move.w  (%a6)+,%d0
    add.w   (%a6)+,%d0
    move.w  %d0,-(%a6)
    bra.b   do_next
/* do_code */


    .org    0x2000 /*dict_top */

entry_000:  /* entry "abc" */
e_abc:
    dc.b   3        /* name length. strlen("abc") +1 (if length is even) */
    .ascii "abc"
    .align 2
    dc.w   0        /* 0 means "no more entries we have" so top (the last one for searching) */
test_do_list:
    dc.w   do_list  /* machine language subroutine address */
    /* entry address list, execute them by 'do_list' subroutine */
    dc.w   do_lit
    dc.w   1
    dc.w   do_lit
    dc.w   2
    dc.w   do_add
    dc.w   do_exit
entry_001:  /* entry "defgh" */
e_defgh:
    dc.b   5
    .ascii "defgh"
    .align 2
    dc.w   entry_000
    dc.w   do_code
    mov.w  #1,-(%a5)        /* a5 is DSP */
    mov.w  #2,-(%a5)
    mov.w  (%a5)+,%d0
    add.w  (%a5)+,%d0
    mov.w  %d0,-(%a5)
    rts
entry_002:  /* entry "'", do_lit */
    dc.b   1
    .ascii "'"
    .align 2
    dc.w   entry_001
    dc.w   do_lit
