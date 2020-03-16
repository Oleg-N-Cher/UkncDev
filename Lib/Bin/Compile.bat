@ECHO OFF
IF NOT "%XDev%"=="" GOTO XDev
ECHO Please set system variable XDev=X:\Path\To\XDev
PAUSE
EXIT

:XDev

CD ..\Obj
IF EXIST %1.MAC DEL /Q %1.MAC
IF EXIST %1.OBJ DEL /Q %1.OBJ
..\..\Bin\rt11.exe RUN PASDWK %1.PAS %1.MAC
IF EXIST %1.MAC ..\..\Bin\rt11.exe MACRO %1.MAC
IF EXIST %1.OBJ COPY /B /Y %1.OBJ ..\..\Obj >NUL
IF EXIST %1.OBJ MOVE /Y %1.OBJ .. >NUL

PAUSE
