(*$GPCP*)(*$E+*)(*$T-*)

/*================================ Header =================================*/

VAR crtflg: INTEGER;

PROCEDURE CrtInit;
BEGIN /*$C
        .TITLE  CRT001
        MOV     @#^O177560, crtflg
        BIC     #^O100, @#^O177560
*/
END {CrtInit};

PROCEDURE CrtQuit;
BEGIN /*$C
        MOV     crtflg, @#^O177560
*/
END {CrtQuit};

/*------------------------------- Cut here --------------------------------*/

FUNCTION GetKey : INTEGER;
BEGIN /*$C
        .TITLE  CRT002
        .GLOBL  RETKEY
        CLR     R1
        TSTB    @#^O177560         ; is char?
        BPL     RETN$              ; no char => return 0
RETKEY: MOVB    @#^O177562, R1     ; A key code
        CMPB    R1, #^O33
        BNE     RETN$
ESCKEY: TSTB    @#^O177560
        BPL     ESCKEY
        MOVB    @#^O177562, R1     ; char => low byte
        BIS     #^O15400, R1       ; ^O33 => high byte
RETN$:  MOV     R1, 12(SP)         ; return result
*/
END {GetKey};

/*------------------------------- Cut here --------------------------------*/

FUNCTION WaitKey : INTEGER;
BEGIN /*$C
        .TITLE  CRT003
WTKEY$: TSTB    @#^O177560         ; Ready?
        BPL     WTKEY$             ; No!
        JMP     RETKEY
*/
END {WaitKey};

/*------------------------------- Cut here --------------------------------*/

