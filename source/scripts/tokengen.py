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

import sys,os
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
for k in keywords:
	h.write("\t.byte\t${0:02x}\t\t; ${1:02x} : {2}\n".format(tokens[k]["control"],tokens[k]["id"],k.lower()))
h.close()

# *************************************************************************************
#			  Scan source files for keyword markers and create jump tables
# *************************************************************************************

# TODO:
