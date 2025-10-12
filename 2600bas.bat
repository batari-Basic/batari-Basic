@echo off
REM 2600basic compilation script (WASM via Wasmtime, Windows-safe)

setlocal

if X"%bB%"==X goto nobasic

REM --- Check if wasmtime is available ---
wasmtime --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ### ERROR: Wasmtime is not installed or not in PATH.
    exit /b 1
)

echo Using bB=%bB%

REM --- Display tool versions ---
for /F "delims=" %%v in ('wasmtime "%bB%\2600basic.wasm" -v 2^>nul') do set BASVER=%%v
echo   basic version: %BASVER%
for /F "delims=" %%v in ('wasmtime "%bB%\dasm.wasm" 2^>nul') do set DASMVER=%%v & goto dasmgotver
:dasmgotver
echo   dasm version: %DASMVER%


REM --- Source file check ---
if "%~1"=="" (
    echo ### ERROR: No source file specified.
    exit /b 1
)

if /i "%~1"=="-v" (
    REM Just version check
    exit /b 0
)

set srcfile=%~nx1
set srcbase=%~n1
set srcdir=%~dp1
if "%srcdir:~-1%"=="\" set srcdir=%srcdir:~0,-1%

echo.
echo Starting build of %srcfile%

REM --- Preprocess and Compile ---
wasmtime run --dir . --dir "%srcdir%" --dir "%bB%" "%bB%\preprocess.wasm" <"%~f1" | wasmtime run --dir . --dir "%srcdir%" --dir "%bB%" "%bB%\2600basic.wasm" -i "%bB%" > bB.asm
if errorlevel 1 goto basicerror

REM --- Postprocess / Optimize ---
if /I "%2"=="-O" (
    wasmtime run --dir . --dir "%srcdir%" --dir "%bB%" "%bB%\postprocess.wasm" -i "%bB%"  ^
    | wasmtime run --dir "%srcdir%" --dir "%bB%" "%bB%\optimize.wasm" > "%~1.asm"
) else (
    wasmtime run --dir . --dir "%srcdir%" --dir "%bB%" "%bB%\postprocess.wasm" -i "%bB%" > "%~1.asm"
)

REM --- Assemble final binary ---
wasmtime run --dir . --dir "%srcdir%" --dir "%bB%\includes" ^
  "%bB%\dasm.wasm" "%~1.asm" -I. -I"%bB%\includes" -f3 -p20 -l"%~1.list.txt" -s"%~1.symbol.txt" -o"%~1.bin" | wasmtime run --dir . --dir "%srcdir%" --dir "%bB%" "%bB%\bbfilter.wasm"

REM --- Create an ACE file if the binary is DPC+ ---
wasmtime run --dir "%CD%::/" --dir "%bB%::/bB" "%bB%\relocateBB.wasm" "%~nx1.bin"

goto end

:basicerror
echo.
echo ### ERROR: 2600basic compilation failed.
exit /b 1

:nobasic
echo.
echo ### ERROR: bB not defined.
exit /b 1

:end
endlocal
exit /b 0


