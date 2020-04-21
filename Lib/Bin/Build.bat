@ECHO OFF
IF NOT "%XDev%"=="" GOTO XDev
ECHO Please set system variable XDev=X:\Path\To\XDev
PAUSE
EXIT

:XDev

SET smartlib=%XDev%\Bin\smartlib.exe
CD ..\Obj

%smartlib% %1.PAS %2
DEL /Q %1.PAS

..\..\Bin\rt11.exe RUN PASDWK CG001.PAS CG001.MAC
..\..\Bin\rt11.exe RUN PASDWK CG002.PAS CG002.MAC
..\..\Bin\rt11.exe RUN PASDWK CG003.PAS CG003.MAC
..\..\Bin\rt11.exe RUN PASDWK CG004.PAS CG004.MAC
..\..\Bin\rt11.exe RUN PASDWK CG005.PAS CG005.MAC
..\..\Bin\rt11.exe RUN PASDWK CG006.PAS CG006.MAC
..\..\Bin\rt11.exe RUN PASDWK CG007.PAS CG007.MAC
..\..\Bin\rt11.exe RUN PASDWK CG008.PAS CG008.MAC
..\..\Bin\rt11.exe RUN PASDWK CG009.PAS CG009.MAC
..\..\Bin\rt11.exe RUN PASDWK CG010.PAS CG010.MAC

:: MACRO/LIST:DK:
FOR %%i IN (%2???.MAC) DO ..\..\Bin\rt11.exe MACRO %%i

IF EXIST %1.OBJ DEL /Q %1.OBJ
..\..\Bin\rt11.exe RUN LIBR %1=CG001,CG002,CG003,CG004,CG005,CG006
..\..\Bin\rt11.exe LIBR %1 CG007
..\..\Bin\rt11.exe LIBR %1 CG008
..\..\Bin\rt11.exe LIBR %1 CG009
..\..\Bin\rt11.exe LIBR %1 CG010

::..\..\Bin\rt11.exe LIBR/C %1 CG001
IF EXIST %1.OBJ COPY /B /Y %1.OBJ ..\..\Obj >NUL
IF EXIST %1.OBJ MOVE /Y %1.OBJ .. >NUL

PAUSE
DEL /Q *.MAC
DEL /Q *.OBJ
DEL /Q *.PAS
