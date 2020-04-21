@ECHO OFF
IF NOT "%XDev%"=="" GOTO XDev
ECHO Please set system variable XDev=X:\Path\To\XDev
PAUSE
EXIT

:XDev

SET Lib=CRT
SET smartlib=%XDev%\Bin\smartlib.exe
CD ..\Obj

%smartlib% %Lib%.PAS CRT
DEL /Q %Lib%.PAS

..\..\Bin\rt11.exe RUN PASDWK CRT001.PAS CRT001.MAC
..\..\Bin\rt11.exe RUN PASDWK CRT002.PAS CRT002.MAC
..\..\Bin\rt11.exe RUN PASDWK CRT003.PAS CRT003.MAC
..\..\Bin\rt11.exe RUN PASDWK CRT004.PAS CRT004.MAC

FOR %%i IN (CRT???.MAC) DO ..\..\Bin\rt11.exe MACRO %%i

IF EXIST %Lib%.OBJ DEL /Q %Lib%.OBJ
..\..\Bin\rt11.exe RUN LIBR %Lib%=CRT001,CRT002,CRT003,CRT004

IF EXIST %Lib%.OBJ COPY /B /Y %Lib%.OBJ ..\..\Obj >NUL
IF EXIST %Lib%.OBJ MOVE /Y %Lib%.OBJ .. >NUL

PAUSE
DEL /Q *.MAC
DEL /Q *.OBJ
DEL /Q *.PAS
