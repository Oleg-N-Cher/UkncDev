PROGRAM TstKey; (*$GPCP*)(*$T-*)

PROCEDURE CrtInit; EXTERNAL;
PROCEDURE CrtQuit; EXTERNAL;
FUNCTION GetKey : INTEGER; EXTERNAL;
FUNCTION WaitKey : INTEGER; EXTERNAL;

VAR
  code: INTEGER;

BEGIN
  CrtInit;
  WriteLn('Ready>');
  REPEAT
    code := WaitKey;
    WriteLn('"', CHR(code), '"', code)
  UNTIL code = 32;
  CrtQuit
END {TstKey}.
