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

goto end

:nobb
echo bB environment variable not set.

:bBerror
echo Compilation failed.

:end
