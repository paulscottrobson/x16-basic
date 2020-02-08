# *************************************************************************************
# *************************************************************************************
#
#		Name : 		baspgm.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Text to Tokenised BASIC converter
#		Date :		8th February 2020
#
# *************************************************************************************
# *************************************************************************************

import re
from tokeniser import *

class BasicProgram(object):
	def __init__(self):
		self.code = []
		self.nextLine = 1000
		self.lineStep = 10
		self.tokeniser = Tokeniser()
	#
	#		Add a file
	#
	def addFile(self,fileName):
		for l in open(fileName).readlines():
			if l.strip() != "" and not l.startswith("//"):
				self.addLine(l)
	#
	#		Add a single line.
	#
	def addLine(self,txt):
		txt = txt.replace("\t"," ").strip()
		m = re.match("^(\d+)\\s+(.*)$",txt)
		if m is not None:
			n = int(m.group(1))
			assert n >= self.nextLine,"Line sequence "+txt
			self.nextLine = n
			txt = m.group(2).strip()
		#
		lineCode = self.tokeniser.tokenise(txt)
		self.code += [ len(lineCode)+4,self.nextLine & 0xFF,self.nextLine >> 8] + lineCode + [0x80]
	#
	#		Output the final file.
	#
	def write(self,binFile):
		h = open(binFile,"wb")
		h.write(bytes(self.code+[0]))
		h.close()

if __name__ == '__main__':
	bp = BasicProgram()
	bp.addFile("test.bas")
	bp.write(".."+os.sep+"generated"+os.sep+"bascode.bin")