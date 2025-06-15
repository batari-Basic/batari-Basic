@echo off
if X"%bB%" == X goto nobb
preprocess <"%~f1" | 2600basic.exe -i "%bB%" > bB.asm
if errorlevel 1 goto bBerror
if X%2 == X-O goto optimize
postprocess -i "%bB%" > "%~f1.asm"
goto nooptimize
:optimize
postprocess -i "%bB%" | optimize >"%~f1.asm"
:nooptimize

dasm "%~f1.asm" -I"%bB%"/includes -f3 -l"%~f1.lst" -s"%~f1.sym" -o"%~f1.bin" | bbfilter
if errorlevel 1 goto dasmerror

relocateBB.exe "%~f1.bin" 2>NUL

goto end

:nobb
echo bB environment variable not set.
goto end

:bBerror
echo Compilation failed.
goto end

:dasmerror
echo Assembly failed.

:end
