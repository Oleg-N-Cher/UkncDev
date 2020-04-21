(*$GPCP*)(*$E+*)(*$T-*)

/*================================ Header =================================*/

PROCEDURE InitGraph;
BEGIN /*$C
        .TITLE  CG001
        .GLOBL TTYOUT
        BIS     #^O10000, @#^O44        ; Disable Ctrl-C
        MOV     #INIT$, R0
TTYOUT: TSTB    @#^O177564
        BPL     TTYOUT
        MOVB    (R0)+, @#^O177566
        BNE     TTYOUT
*/
END {InitGraph};

/*$C
INIT$:  .BYTE   ^O33, ^O246, ^O62       ; Screen mode 40x24
        .BYTE   ^O33, ^O45, ^O41, ^O61  ; Text mode 1
        .BYTE   ^O33, ^O133, ^O60, ^O73, ^O60, ^O162
        .BYTE   ^O33, ^O45, ^O41, ^O60  ; Graph
        .BYTE   0
*/

/*------------------------------- Cut here --------------------------------*/

PROCEDURE CloseGraph;
BEGIN /*$C
        .TITLE  CG002
        MOV     #CLOSE$, R0
        JMP     TTYOUT
*/
END {CloseGraph};

/*$C
CLOSE$: .BYTE   ^O33, ^O45, ^O41, ^O63  ; Text mode 3
        .BYTE   ^O33, ^O246, ^O61       ; Screen mode 80x24
        .BYTE   ^O14
        .BYTE   0, 0
*/

/*------------------------------- Cut here --------------------------------*/

PROCEDURE ClearDevice;
BEGIN /*$C
        .TITLE  CG003
        MOV     R2, -(SP)
        MOV     #^O176640, R0
        MOV     #^O176642, R1
        MOV     #^O100000, R2
        MOV     R2, @R0
1$:     CLR     @R1
        INC     @R0
        SOB     R2, 1$
        MOV     (SP)+, R2
*/
END {ClearDevice};

/*------------------------------- Cut here --------------------------------*/

PROCEDURE Palette (n: INTEGER);
BEGIN /*$C
        .TITLE  CG004
        MOV     #^O146000, R0      ; #CC00
        MOV     #^O167252, R1      ; #EEAA
        BICB    #^O177774, 2(SP)
        BEQ     PALET$
        MOV     #^O135631, R0      ; #BB99
        MOV     #^O177735, R1      ; #FFDD
        DEC     2(SP)
        BEQ     PALET$
        MOV     #^O42000, R0       ; #4400
        MOV     #^O21146, R1       ; #2266
        DEC     2(SP)
        BEQ     PALET$
        MOV     #^O31421, R0       ; #3311
        MOV     #^O73525, R1       ; #7755
PALET$: CALL    PALET
*/
END {Palette};

/*------------------------------- Cut here --------------------------------*/

PROCEDURE SetPalette (c0, c1, c2, c3: INTEGER);
BEGIN /*$C
        .TITLE  CG005
        BICB    #^O177760, 8(SP)
        BICB    #^O177760, 6(SP)
        MOVB    6(SP), R0
        ASH     #4, R0
        ADD     6(SP), R0
        ASH     #4, R0
        ADD     8(SP), R0
        ASH     #4, R0
        ADD     8(SP), R0
        BICB    #^O177760, 4(SP)
        BICB    #^O177760, 2(SP)
        MOVB    2(SP), R1
        ASH     #4, R1
        ADD     2(SP), R1
        ASH     #4, R1
        ADD     4(SP), R1
        ASH     #4, R1
        ADD     4(SP), R1
        CALL    PALET
*/
END {SetPalette};

/*$C
        .GLOBL  NEWPAL
        .GLOBL  PALET
PALET:  MOV     R0, NEWPAL
        MOV     R1, NEWPAL+2
        MOV     #BUF0, R0
        MOV     #5, R1
        MTPS    #^O200
        BR      2$
1$:     MOVB    (R0)+, @#^O176676
2$:     TSTB    @#^O176674
        BPL     2$
        SOB     R1, 1$
        MTPS    #0
        RETURN
BLK:    .WORD   ^O20*^O400, ^O32, ^O2470, NEWPAL, 2
BUF0:   .WORD   BLK, -1
NEWPAL: .WORD   ^B1110111011001100, ^B1010101010001000
*/

/*------------------------------- Cut here --------------------------------*/

VAR XLast, YLast: INTEGER;

PROCEDURE PutPixel (x, y, color: INTEGER);
BEGIN /*$C
        .TITLE  CG006
        MOV     6(SP), XLast
        MOV     4(SP), YLast
        MOV     6(SP), R1
        BIC     #^O177770, R1
        MOV     #1, R0
        ASH     R1, R0
        MOV     4(SP), R1
        MUL     #^O120, R1
        BIS     #^O100000, R1
        MOV     R1, @#^O176640
        MOV     6(SP), R1
        ASH     #-3, R1
        ADD     R1, @#^O176640
        BICB    R0, @#^O176642
        BICB    R0, @#^O176643
        BIT     #1, 2(SP)
        BEQ     1$
        BISB    R0, @#^O176642
1$:     BIT     #2, 2(SP)
        BEQ     2$
        BISB    R0, @#^O176643
2$: */
END {PutPixel};

/*------------------------------- Cut here --------------------------------*/

FUNCTION GetPixel (x, y: INTEGER): INTEGER;
BEGIN /*$C
        .TITLE  CG007
        MOV     2(SP), R1
        BIC     #^O177770, R1
        MOV     #1, R0
        ASH     R1, R0
        MOV     4(SP), R1
        MUL     #^O120, R1
        BIS     #^O100000, R1
        MOV     R1, @#^O176640
        MOV     2(SP), R1
        ASH     #^O177775, R1
        ADD     R1, @#^O176640
        BICB    R0, @#^O176642
        BICB    R0, @#^O176643
        CLR     R1
        BITB    R0, @#^O176642
        BEQ     1$
        BIS     #1, R1
1$:     BITB    R0, @#^O176643
        BEQ     2$
        BIS     #2, R1
2$:     MOV     R1, R0
*/
END {GetPixel};

/*------------------------------- Cut here --------------------------------*/

PROCEDURE PutOr (x, y: INTEGER; PROCEDURE spr);
BEGIN /*$C
        .TITLE  CG008
        MOV     R2, -(SP)
        MOV     R3, -(SP)
        MOV     R4, -(SP)
        MOV     R5, -(SP)
        MOV     16(SP), R4         ; X
        MOV     14(SP), R3         ; Y
        MOV     10(SP), R5         ; R5 - pointer to sprite
;----------------------------------------------
        CALL    XYTOSC             ; R3 - adr of videobuf. R4 - shift
        MOV     R3, @#^O176640
        MOV     (R5)+, R0          ; sprite size
        CLR     R1
        BISB    R0, R1             ; width
        BIC     #^O177400, R1
        SWAB    R0
        BIC     #^O177400, R0      ; height
        MOV     R1, R3
        MOV     R0, 3$+2
        MOV     R4, R0
        ADD     R0, R0
        ADD     #MASK29, R0
        MOV     (R0), 5$+2
22$:    MOV     R3, -(SP)          ; Save R3 on the stack
        MOV     @#^O176640, -(SP)  ; Save the register of adr of plans 1, 2 on the stack
11$:    CLR     R0                 ; R0 = 0
        MOV     (R5)+, R1          ; (R5)+ -> R1
        ASHC    R4, R0             ; R0.R1 << R4
        BIS     R0, R1             ; R1 = (R5)+ rol R4
        MOV     R1, R0
5$:     BIC     #^O7417, R0        ; Stay the highest parts of the shifted bytes 0x0f0f
        BIS     R0, @#^O176642     ; (plan 1, 2) = (plan 1, 2) | R0
        INC     @#^O176640         ; Increment the address register of plans 1, 2
        BIC     R0, R1             ; Stay the lowest parts of the shifted bytes
        SWAB    R1
        BIS     R1, @#^O176642     ; (plan 1, 2) = (plan 1, 2) | R1
        SOB     R3, 11$            ; Loop on R3 iterations
        MOV     (SP)+, @#^O176640                  
        ADD     #80., @#^O176640
        MOV     (SP)+, R3
3$:     DEC     #0
        BNE     22$
;----------------------------------------------
6$:     MOV     (SP)+, R5
        MOV     (SP)+, R4
        MOV     (SP)+, R3
        MOV     (SP)+, R2
*/
END {PutOr};

/*$C
;-----------------------------------------------------------------
; Convert the X, Y into address at the screen R3 and the offset R4
;     In:  R3 = Y  R4 = X
;     Out: R3 = address at the screen, R4 = offset 0..7
;-----------------------------------------------------------------
XYTOSC: MOV     #^O100000, R0      ; Start of video memory
        MOV     R4, R2             ; take X
        ASR     R2
        ASR     R2
        ASR     R2                 ; getting the number of a byte in line
        ADD     R2, R0             ; got the address at the screen
        BIC     #^O177770, R4      ; staying only the offset 0..7
        MOV     R3, R2
        BIC     #^O177400, R3      ; byte Y is now in the lower byte of R3
        MUL     #80., R2
        ADD     R0, R3
        RETURN
;----------------------------------------------------------------
*/

/*------------------------------- Cut here --------------------------------*/
PROCEDURE MASK29;
BEGIN /*$C
        .TITLE  CG009
;----------------------------------------------------------------
        .WORD   ^B0000000000000000
        .WORD   ^B0000000100000001
        .WORD   ^B0000001100000011
        .WORD   ^B0000011100000111
        .WORD   ^B0000111100001111
        .WORD   ^B0001111100011111
        .WORD   ^B0011111100111111
        .WORD   ^B0111111101111111
        .WORD   ^B1111111111111111
*/
END {MASK29};

/*------------------------------- Cut here --------------------------------*/

PROCEDURE PutSpr (x, y: INTEGER; PROCEDURE spr);
BEGIN /*$C
        .TITLE  CG010              ; Coded by BlaireCas, 2020
        MOV     R2, -(SP)
        MOV     R3, -(SP)
        MOV     R4, -(SP)
        MOV     R5, -(SP)
        MOV     16(SP), R4         ; X
        MOV     14(SP), R3         ; Y
        MOV     10(SP), R5         ; R5 - pointer to sprite
        MOV     (R5), -(SP)        ; DX
        MOV     (R5)+, -(SP)       ; DX
        MOV     (R5)+, -(SP)       ; DY
        MOV     R5, -(SP)          ; spraddr w/o dx, dy
        TST     -(SP)              ; reserving for vaddr
;----------------------------------------------

        MOV     R3, R1             ; R0 = DY*80
        ASH     #3, R1             ; ^_^
        MOV     R1, R0             ; change to mul
        MOV     R3, R1             ; it is just for fun
        ASH     #1, R1             ; dunno will it be faster
        ADD     R1, R0
        ASH     #3, R0

        MOV     R4, R1
        ASH     #-3, R1
        ADD     R1, R0             ; R0 += DX/8
        ADD     #^O100000, R0
        MOV     R0, @#^O176640     ; vaddr
        MOV     R0, (SP)           ; vaddr -> (SP)

        MOV     R4, R0             ; shift value
        BIC     #^B1111111111111000, R0 ; if it = 0 - use simple sprite out
        BNE     10$

; // sprite out with X aligned to 8 pix //

        MOV     #^O176642, R0
        MOV     #^O176640, R1
        MOV     #80., R3
        SUB     6(SP), R3
2$:     MOV     6(SP), R2          ; DX
4$:     MOV     (R5)+, (R0)
        INC     (R1)
        SOB     R2, 4$             ; cycle by DX
        ADD     R3, (R1)
        DEC     4(SP)              ; cycle by DY
        BNE     2$
        JMP     99$

; // sprite out with arbitrary X //

10$:    MOV     R0, R3             ; R3 = shift value
        ASL     R0
        MOV     MASK29(R0), R4     ; R4 = mask value

        ASL     6(SP)              ; DX = DX * 2
20$:
    ; // draw first DY part //
    
        MOV     (SP), @#^O176640   ; vaddr
        MOV      2(SP), R5         ; spraddr
        MOV     4(SP), R2          ; DY
30$:    MOV     (R5), R1
        ASH     R3, R1
        BIC     R4, R1
        COM     R4
        MOV     @#^O176642, R0
        BIC     R4, R0
        COM     R4
        BIS     R1, R0
        MOV     R0, @#^O176642
        ADD     #80, @#^O176640
        ADD     6(SP), R5          ; R5 = R5+DX2 
        sob     R2, 30$

        INC     (SP)               ; inc vaddr

        ; // draw second DY part //

        MOV     (SP), @#^O176640   ; vaddr
        MOV     2(SP), R5          ; spraddr
        MOV     4(SP), R2          ; DY
        COM     R4                 ; invert mask
40$:    MOV     (R5), R1
        SWAB    R1
        MOVB    R1, R0
        ASHC    R3, R0             ; R0:R1 << R3
        BIC     R4, R0             ; apply mask
        COM     R4
        MOV     @#^O176642, R1
        BIC     R4, R1
        COM     R4
        BIS     R0, R1
        MOV     R1, @#^O176642
        ADD     #80, @#^O176640
        ADD     6(SP), R5
        SOB     R2, 40$

        COM     R4                 ; invert mask
        ADD     #2, 2(SP)          ; spraddr += 2

        DEC     8(SP)              ; cycle by DX
        BNE     20$

;----------------------------------------------
99$:    TST     (SP)+
        TST     (SP)+
        TST     (SP)+
        TST     (SP)+
        TST     (SP)+
        MOV     (SP)+, R5
        MOV     (SP)+, R4
        MOV     (SP)+, R3
        MOV     (SP)+, R2
*/
END {PutSpr};
