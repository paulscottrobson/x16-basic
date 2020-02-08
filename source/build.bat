@echo off
rem
rem		Delete old files
rem
del /Q dump.bin basic_nocode.prg basic.prg basic.lst >NUL
rem
rem		Generate token tables and demonstration code.
rem
pushd scripts
python tokengen.py
python tokeniser.py
python baspgm.py
python buildtrack.py
popd
rem
rem		Assemble BASIC
rem
64tass -q -c basic.asm -o basic_nocode.prg -L basic.lst -l basic.lbl
if errorlevel 1 goto exit
rem
rem		Append converted code binary to basic executable.
rem
copy /B basic_nocode.prg +generated\bascode.bin basic.prg
rem
rem		Run on emulator. Path may need amending.
rem
..\..\x16-r36\x16emu -scale 2 -prg basic.prg -run -dump R -debug
rem
rem		Examine binary dump.
rem
pushd scripts
python showstack.py
popd
:exit