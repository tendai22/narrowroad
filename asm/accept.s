/*  definitions */
 .equ ram,  0
 .equ start,  0x80
 .equ uart_dreg,  0x800A0
 .equ uart_creg,  0x800A1
 .equ HALT_REG,   0x800A2
 .equ dbg_table,  0x80100
 .equ u3txif,  2
 .equ u3rxif,  1

 .equ linbuf, 0x1000
 .equ bufsiz, 64

 .org      ram
    dc.l    0xf000
    dc.l    start
 .org      start
main:
    move.w  #linbuf, %a0
    move.w  #bufsiz, %d1
    jsr     (accept)
halt_loop:
    bra.b   halt_loop
/*
 * accept: line input (aka gets)
 * In:  %a0:  *buf
 *      %d1:  bufsiz
 * Out: %d0:  number of input chars
 */
accept:
    move.w  %a1,-(%a7)      /* push %a1 */
    move.w  %a0,%a1         /* initialize ptr p(as %a1) */
    move.w  %d2,-(%a7)      /* push %d2 */
    move.w  %d1,%d2
    move.w  #0,%d1
acceptl:
    cmp.w   %d1,%d2
    ble     acceptz         /* d1 == d2 -> branch
                             * d1 > d2  -> branch
                             * d1 < d2  -> skip
                             */
    jsr     (getch)
    move.w  %d0,-(%a7)      /* push d0 */
    jsr     (putch)
    move.w  (%a7)+,%d0      /* pop d0 */
    move.b  %d0,(%a1+%d1)   /* buf[i] = c */
    add.q   %d1             /* i++ */
    bra.b   acceptl   
/* end of accept loop */
    move.b  %d1,%d2         /* save counter */
acceptel:
    move.b  (%a1)+,%d0
    jsr     (putch)
    add.b   #-1,%d1
    cmp     #0,%d1
    ble     acceptel   
    move.b  #'\r', %d0
    jsr     (putch)
    move.b  #'\n', %d0
    jsr     (putch)
acceptz1:
    bra.b   acceptz1
acceptz:
    move.b  #'B', %d0
    jsr     (putch)
acceptz2:
    bra.B   acceptz2



    /*move.b  (dbg_table+2),%d0*/
    jsr     (putch)
    jsr     (getch)
    /*move.b  %d0,(dbg_table+3)*/
    bra.b   main
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
