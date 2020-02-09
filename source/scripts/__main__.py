# *************************************************************************************
# *************************************************************************************
#
#		Name : 		__main__.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Basic tokeniser wrapper for basconv.zip
#		Date :		9th February 2020
#
# *************************************************************************************
# *************************************************************************************

import os,sys
from baspgm import *

if len(sys.argv) != 3:
	print("basconv.zip <source filename> <target filename\n\tASCII to tokenised BASIC converter.\n")
	sys.exit(1)
try:
	bp = BasicProgram()
	bp.addFile(sys.argv[1])
	bp.write(sys.argv[2])
	sys.exit(0)
except Exception as e:
	sys.stderr.write(str(e)+"\n")
	sys.exit(1)
