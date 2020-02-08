# *************************************************************************************
# *************************************************************************************
#
#		Name : 		tokengen.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Create token tables.
#		Date :		7th February 2020
#
# *************************************************************************************
# *************************************************************************************

import sys,os,re
from tokens import *

# *************************************************************************************
#				   Get tokens and create raw list in correct order
# *************************************************************************************

tokens = BasicTokens().getTokens()
keywords = [x for x in tokens.keys()]
keywords.sort(key = lambda x:tokens[x]["id"])
genDir = ".."+os.sep+"generated"+os.sep

# *************************************************************************************
#				 Create the table converting tokens to/from text.
# *************************************************************************************

h = open(genDir+"tokentext.inc","w")
h.write(";\n;\tGenerated automatically.\n;\n")
for k in keywords:
	b = [ord(x) for x in k.upper()]												# name text
	b[-1] |= 0x80																# last char has bit 7 set
	b.insert(0,len(b))															# length prefixed
	b = ",".join(["${0:02x}".format(c) for c in b])								# display it.
	h.write("\t.byte\t{0:40} ; ${1:02x} : {2}\n".format(b,tokens[k]["id"],k.lower()))
h.write("\t.byte\t$00\n")														# end marker
h.close()

# *************************************************************************************
#							Create the control byte table
# *************************************************************************************

h = open(genDir+"tokencbyte.inc","w")
h.write(";\n;\tGenerated automatically.\n;\n")
for k in keywords:
	h.write("\t.byte\t${0:02x}\t\t; ${1:02x} : {2}\n".format(tokens[k]["control"],tokens[k]["id"],k.lower()))
h.close()

# *************************************************************************************
#							Create token constants
# *************************************************************************************

h = open(genDir+"tokenconst.inc","w")
h.write(";\n;\tGenerated automatically.\n;\n")
for k in keywords:
	s = k.replace("(","LPAREN").replace(")","RPAREN").replace(":","COLON").replace("=","EQUAL")
	s = s.replace(">","GREATER").replace("<","LESS").replace("+","PLUS").replace("-","MINUS")
	s = s.replace("*","STAR").replace("/","SLASH").replace("$","DOLLAR").replace("#","HASH")
	s = s.replace("%","PERCENT").replace(",","COMMA").replace(";","SEMICOLON").replace("","")
	s = s.replace("","").replace("","").replace("","").replace("","")
	assert re.match("^[a-zA-Z]+$",s) is not None,"Bad "+s
	h.write("TOK_{0} = ${1:02x}\n".format(s.upper(),tokens[k]["id"]))
h.close()

# *************************************************************************************
#			  Scan source files for keyword markers and create jump tables
# *************************************************************************************

tokenHandlers = {}
for root,dirs,files in os.walk(".."):											# search for source files
	for f in [x for x in files if x.endswith(".asm")]:
		for l in open(root+os.sep+f).readlines():
			if l.find(";;") >= 0:												# look for markers
				m = re.match("^(.*?)\\:\\s*\\;\\;\\s*(.*?)\\s*$",l)				# extract
				assert m is not None and len(m.group(2)) > 0,"Line "+l 			# validation
				kwd = m.group(2).strip().upper()
				assert kwd not in tokenHandlers,"Duplicate "+kwd
				tokenHandlers[kwd] = m.group(1).strip()

h = open(genDir+"tokenvectors.inc","w")
h.write(";\n;\tGenerated automatically.\n;\n")
for k in keywords:
	s = tokenHandlers[k] if k in tokenHandlers else "SyntaxError"
	h.write("\t.word\t{0:24}\t\t; ${1:02x} : {2}\n".format(s,tokens[k]["id"],k.lower()))
h.close()	
