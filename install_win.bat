@echo off
setlocal enabledelayedexpansion
echo
echo The bB installation batch file v1.2
echo -----------------------------------
echo.
echo   Permanently setting the bB variable to:
echo.
SET bB=%~dp0
SET bB=%bB:~0,-1%
echo      %bB%
echo.
setx bB %bB%
echo.
set bB=%bB%;
if %ERRORLEVEL% NEQ 0 GOTO FAILED
for /f "usebackq tokens=2,*" %%A in (`reg query HKCU\Environment /v PATH`) do set USERPATH=%%B
IF NOT "%USERPATH%"=="" call set USERPATH=%%USERPATH:!bB!=%%

set USERPATH %bB%%USERPATH% 2>NUL
echo.
echo   Updating the user PATH variable so this bB directory is your primary
echo.
setx PATH "%bB%%USERPATH%"
echo.
:SKIPUPDATE
echo   You should re-open vbb or any command-line windows so they take on the new
echo   bB variable value.
echo.
echo   You should re-run this batch file if you ever change the location of the bB
echo   directory.
echo.
pause
exit

:FAILED
echo   Setting the bB variable failed. This batch file requires SETX, which comes
echo   with WinXP SP2, Windows Vista, and later versions of Windows.
echo.
echo   You should obtain a copy of SETX and re-run this script, or set the bB
echo   variable manually.
echo.
pause
