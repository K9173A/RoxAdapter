@echo off
@rem **************************************************************************
@rem A batch file to copy game dlls into the game folder and to register
@rem ActiveX components. By default (if no args are specified), game is located
@rem in the [...]\Program Files (x86)\RoX\ directory, but you can pass your own
@rem path, if the game was installed in different place.
@rem
@rem Do not move this batchfile anywhere, it's important to keep its location
@rem as is, otherwise it will not be able to copy data from relative path!
@rem **************************************************************************

set gamePath=""
if "%~1" == "" (
	echo Game directory was not specified - trying default one...
	set "gamePath=%windir:~0,3%\Program Files (x86)\RoX\"
) else (
	set "gamePath=%~1"
)

if "%gamePath%" == "help" (
	echo Syntax: register_dll.bat [rox_root_path]
	goto END
)

for /f %%a in ("wmic os get osarchitecture /value") do (
	if %%a equ 64 (
		set regsvrDir=System32
	) else (
		set regsvrDir=SysWOW64
	)
)

for /r %%i in (..\lib\*.dll) do (
	copy "%%~fi" "%gamePath%%%~nxi"
	if "%%~nxi" == "dx8vb.dll" (
		%WINDIR%\%regsvrDir%\regsvr32.exe "%gamePath%dx8vb.dll"
	)
)

:END