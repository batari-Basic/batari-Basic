@echo off
REM Wrapper for running WASM tools via wasmtime with dynamic include directories

setlocal enabledelayedexpansion

wasmtime --version >nul 2>&1
if errorlevel 1 (
  echo ### ERROR: wasmtime not found in PATH
  exit /b 1
)

set TOOL=%~n0
set DIRS=--dir . 
set ARGS=

REM Parse command-line arguments
for %%A in (%*) do (
  set "ARG=%%~A"
  REM Check if it starts with -I
  if "!ARG:~0,2!"=="-I" (
    set "INC=!ARG:~2!"
    REM Add this directory to --dir list
    set DIRS=!DIRS! --dir "!INC!"
  )
)

REM Now run wasmtime
wasmtime run %DIRS% "%bB%\%TOOL%.wasm" %*

endlocal

