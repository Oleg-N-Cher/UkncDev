PROGRAM DURAK; (*$GPCP*)(*$T-*)

PROCEDURE InitGraph; EXTERNAL;
PROCEDURE CloseGraph; EXTERNAL;
PROCEDURE ClearDevice; EXTERNAL;
PROCEDURE Palette (n: INTEGER); EXTERNAL;
PROCEDURE SetPalette (c0, c1, c2, c3: INTEGER); EXTERNAL;
PROCEDURE PutPixel (x, y, color: INTEGER); EXTERNAL;

CONST
  BufLast = 511;

TYPE
  BLOCK      = 0..BufLast;
  BigBuf = ARRAY [BLOCK] OF CHAR;

VAR
  ImgFile    : FILE OF BigBuf;
  EofImgFile : BOOLEAN;
  BufR       : BigBuf;
  IdxR, Size : INTEGER;

PROCEDURE ReadSector;
BEGIN
  BufR := ImgFile^;
  GET(ImgFile);
  IdxR := 0;
  Size := Size - 1;
  IF Size = 0 THEN EofImgFile := TRUE;
END {ReadSector};

PROCEDURE ReadByte (VAR x: CHAR);
BEGIN
  IF EofImgFile THEN x := CHR(0)
  ELSE BEGIN
    x := BufR[IdxR];
    IdxR := IdxR + 1;
    IF IdxR = BufLast+1 THEN ReadSector;
  END;
END {ReadByte};

PROCEDURE StartRead;
BEGIN
  EofImgFile := FALSE;
  ReadSector;
END {StartRead};

CONST BLACK = 0; CYAN = 1; RED = 2; WHITE = 3;

VAR EE, DE, D5, OO, r, g, b: CHAR; x, y, i: INTEGER;

LABEL 0;

BEGIN
  InitGraph; ClearDevice; SetPalette(0, 13, 10, 15);
  x := 0; y := 199;
  EE := CHR(238); DE := CHR(222); D5 := CHR(213); OO := CHR(0);
  Reset(ImgFile, 'Dur6.BMP', '', Size);
  StartRead;
  FOR i := 1 TO 54 DO ReadByte(r);
  WHILE y >= 0 DO BEGIN
    ReadByte(r); ReadByte(g); ReadByte(b);
    (* IF (r=OO) AND (g=OO) AND (b=OO) THEN *)  i := BLACK;
    IF (r=OO) AND (g=OO) AND (b=EE) THEN BEGIN i := RED;   GOTO 0 END;
    IF (r=OO) AND (g=EE) AND (b=EE) THEN BEGIN i := CYAN;  GOTO 0 END;
    IF (r=EE) AND (g=EE) AND (b=EE) THEN BEGIN i := WHITE; GOTO 0 END;
    IF (r=EE) AND (g=OO) AND (b=EE) THEN BEGIN i := RED;   GOTO 0 END;
    IF (r=DE) AND (g=DE) AND (B=OO) THEN BEGIN i := CYAN;  GOTO 0 END;
    IF (r=EE) AND (g=OO) AND (b=OO) THEN BEGIN i := BLACK; GOTO 0 END;
    IF g=D5                         THEN        i:= WHITE;

    0:
    PutPixel(x, y, i);
    x:=x+1; if x >= 256 then begin x := 0; y:=y-1 end;
  END;
  Close(ImgFile); WriteLn('File closed!');

{
  WHILE NOT EOF(f) DO BEGIN
    Read(f, ch);
    IF ch = CHR(238-256) THEN ch := CHR(0);
    IF ch = CHR(222-256) THEN ch := CHR(0);
    IF ch = CHR(-64) THEN ch := CHR(0);
    IF ch <> CHR(0) THEN BEGIN write(ch);write(ORD(ch)) END;
  END;
}
(*
  IF en <= 0 THEN writeln('No file');
  if zag.bfType<>19778 then writeln('Not a .BMP file');
  if zag.biBitCount<>8 then writeln('File must be 256 colors');
  if zag.biClrUsed=0 then zag.biClrUsed:=256;
*)

(*
  FOR i := 0 TO 319 DO PutPixel(i, 250, 2);
  FOR i := 0 TO 319 DO PutPixel(i, 263, 2);
  FOR i := 0 TO 263 DO PutPixel(i, i, 3);
  FOR i := 0 TO 263 DO PutPixel(i, 263-i, 1);
  PutPixel(100, 31, 0); PutPixel(50, 51, 1);
*)
  REPEAT UNTIL FALSE
END {DURAK}.
