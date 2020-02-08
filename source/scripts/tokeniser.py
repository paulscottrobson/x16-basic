# *************************************************************************************
# *************************************************************************************
#
#		Name : 		tokeniser.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Tokeniser class
#		Date :		7th February 2020
#
# *************************************************************************************
# *************************************************************************************

import os,re,sys
from tokens import *

# *************************************************************************************
#
#						Class that tokenises text strings
#
# *************************************************************************************

class Tokeniser(object):
	def __init__(self):
		self.tokens = BasicTokens().getTokens()		
	#
	#		Tokeniser code.
	#
	def tokenise(self,s):
		s = s.strip().replace("\t"," ")										# preprocess
		self.code = [] 														
		while s != "":
			s = self.tokeniseOne(s).strip()
		return self.code
	#
	#		Tokenise one element
	#
	def tokeniseOne(self,s):
		#
		m = re.match("^([0-9]+)(.*)$",s)									# decimal constant.
		if m is not None:
			self.tokeniseConstant(int(m.group(1)))
			return m.group(2)
		#
		m = re.match("^\\$([a-fA-F0-9]+)(.*)$",s)							# hexadecimal constant.
		if m is not None:
			self.code.append(self.tokens["$"]["id"])						# add marker
			self.tokeniseConstant(int(m.group(1),16))						# add value
			return m.group(2)
		#
		m = re.match("^\\%([01]+)(.*)$",s)									# binary constant.
		if m is not None:
			self.code.append(self.tokens["%"]["id"])						# add marker
			self.tokeniseConstant(int(m.group(1),2))
			return m.group(2)
		#
		m = re.match('^\\"(.*?)\\"(.*)$',s)									# string constant
		if m is not None:
			self.tokeniseString(m.group(1))
			return m.group(2)
		#			
		m = re.match("^([a-zA-Z][a-zA-Z0-9\\.]*)(.*)$",s)					# identifier, might be token.
		if m is not None:
			self.tokeniseIdentifier(m.group(1).upper())
			return m.group(2)
		#
		if s[:2] in self.tokens:											# check for punctuation 2 or 1
			self.code.append(self.tokens[s[:2]]["id"])						# character
			return s[2:]
		if s[0] in self.tokens:		
			self.code.append(self.tokens[s[0]]["id"])		
			return s[1:]
		#
		assert False,"Cannot tokenise "+s 									# give up.
	#
	#		Tokenise a constant.
	#
	def tokeniseConstant(self,n):
		n = n & 0xFFFF														# force intro range.
		if n < 32: 															# short constant
			self.code.append(n+0x60)
		elif n < 256:														# byte constant
			self.code.append(0xFE)
			self.code.append(n)
		else:																# integer constant
			self.code.append(0xFE)
			self.code.append(n & 0xFF)
			self.code.append(n >> 8)
	#
	#		Tokenise a string
	#
	def tokeniseString(self,s):
		self.code.append(0xFB)												# marker
		self.code.append(len(s))											# length
		self.code += [ord(x) for x in s]									# characters
	#
	#		Tokenise identifier or token
	#
	def tokeniseIdentifier(self,s):
		if s in self.tokens:												# known token ?
			self.code.append(self.tokens[s]["id"])
		else: 																# no, do as identifier.
			s = [self.convertCharacter(c)+0x30 for c in s]					# convert it
			s[-1] = s[-1] - 0x30											# mark identifier end
			self.code += s
	#
	#		Convert character to internal format
	#
	def convertCharacter(self,c):
		if c >= 'A' and c <= 'Z':											# A-Z is 0-25
			return ord(c) - ord('A')
		if c >= '0' and c <= '9':											# 0-9 is 26-35
			return int(c)+26
		if c == '.':														# is 36
			return 36
		assert "Internal error "+c
	#
	#		Simple test harness
	#
	def test(self,s):
		print(">>> {0}".format(s))
		code = self.tokenise(s)
		print("\t{0}\n".format(",".join(["${0:02x}".format(c) for c in code])))


if __name__ == '__main__':
	if False:
		Tokeniser().test(" 22 42 522 $2C %1011")
		Tokeniser().test(' "Hello"')
		Tokeniser().test("ABC >= 4 > 2")
		Tokeniser().test(" A FORT FOR A.9 ")
	#
	s = "12+4+5"
	code = Tokeniser().tokenise(s)
	h = open(".."+os.sep+"generated"+os.sep+"testcode.inc","w")
	h.write("\t.byte\t{0}\n\n".format(",".join(["${0:02x}".format(c) for c in code])))
	h.close()