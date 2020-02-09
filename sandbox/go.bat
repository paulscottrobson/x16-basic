@echo off

rem ****************************************************************************************
rem
rem		This is an example of running BASIC programs by converting them from ASCII files
rem 	It is not possible to directly edit before version Alpha 6
rem
rem ****************************************************************************************

rem
rem		This converts the ASCII file 'program.base' to a tokenised binary 'program.bin'
rem
python basconv.zip program.bas program.bin
if errorlevel 1 goto exit

rem
rem		The interpreter is at present a program in memory. This creates a 'runnable' 
rem 	interpreter + code by appending the tokenised binary to the binary.
rem
copy /B basic_nocode.prg +program.bin basic_run.prg

rem
rem		Run the interpreter + code file on the emulator. Note that the Path to the x16
rem 	emulator may need to be changed. 
rem
..\..\x16-r36\x16emu -scale 2 -prg basic_run.prg -run -debug

:exit