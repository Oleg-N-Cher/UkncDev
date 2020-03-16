@ECHO OFF
IF NOT "%XDev%"=="" GOTO XDev
ECHO Please set system variable XDev=X:\Path\To\XDev
PAUSE
EXIT

:XDev

SET Lib=CGLIB

CD ..\Obj
IF EXIST %1.MAC DEL /Q %1.MAC
IF EXIST %1.OBJ DEL /Q %1.OBJ
IF EXIST %1.SAV DEL /Q %1.SAV
..\Bin\rt11.exe RUN PASDWK %1.PAS %1.MAC
IF EXIST %1.MAC ..\Bin\rt11.exe MACRO %1.MAC
::IF EXIST %1.MAC DEL /Q %1.MAC
IF EXIST %1.PAS DEL /Q %1.PAS
IF EXIST %1.OBJ ..\Bin\rt11.exe RUN LINK %1,%Lib%,PASDWK AK.SAV
IF EXIST %1.OBJ DEL /Q %1.OBJ

IF NOT EXIST AK.SAV EXIT
MOVE /Y AK.SAV DEMUK.SAV
::..\Bin\rt11.exe RUN %1.SAV
..\Bin\rt11dsk.exe d ..\Durak.dsk DEMUK.SAV
..\Bin\rt11dsk.exe a ..\Durak.dsk DEMUK.SAV
PAUSE
