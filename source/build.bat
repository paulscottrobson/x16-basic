@echo off
del /Q dump.bin basic.prg basic.lst
pushd scripts
python tokengen.py
python tokeniser.py
popd
64tass -q -c basic.asm -o basic.prg -L basic.lst -l basic.lbl
if errorlevel 1 goto exit
..\..\x16-r36\x16emu -scale 2 -prg basic.prg -run -dump R -debug
pushd scripts
python showstack.py
popd
:exit