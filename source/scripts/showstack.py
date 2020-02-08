# *************************************************************************************
# *************************************************************************************
#
#		Name : 		showstack.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Show stack contents/variables/whatever
#		Date :		8th February 2020
#
# *************************************************************************************
# *************************************************************************************

import re,os,sys

def read(lbl,offset):
	return binFile[labels[lbl.upper()]+(offset & 0xFFFF)]
#
#		Read dump file
#
if not os.path.isfile(".."+os.sep+"dump.bin"):
	sys.exit(0)
binFile = [x for x in open(".."+os.sep+"dump.bin","rb").read(-1)]
#
#		Get label values from assembler file.
#
labels = { "":0 }
for l in [x for x in open(".."+os.sep+"basic.lbl").readlines() if x.find("=") >= 0]:
	m = re.match("^(.*)\\=\\s*(.*)$",l)
	assert m is not None,"Can't process "+l
	s = m.group(2).strip()
	s = int(s[1:],16) if s.startswith("$") else int(s)
	labels[m.group(1).upper().strip()] = s
#
#		Display four levels of stack.
#
print("Expression Stack:")
for lv in range(0,4):
	status = read("xsStatus",lv)
	n = read("xsIntLow",lv)+read("xsIntHigh",lv)*256
	n = n if (n & 0x8000) == 0 else n - 65536
	print("\tLevel {0}\n\t\t{5:6} ${6:04x} Status:${1:02x} {2} {3} {4}".format(lv,status,
		"float" if (status & 0x80) else "integer",
		"string" if (status & 0x40) else "number",
		"reference" if (status & 0x01) else "value",n,n & 0xFFFF))
	if (status & 0x40) != 0:
		s = "".join([chr(read("",i+1+n)) for i in range(0,read("",n))])
		print('\t\t"{0}"'.format(s))
#
#		Display Variables
#
print("Variables:")
for v in range(0,26):
	n = read("variables",v*5)+read("variables",v*5+1)*256
	n = n if (n & 0x8000) == 0 else n - 65536
	if n != 0:
		print("\t{0} = {1:6} ${2:04x}".format(chr(v+65),n,n & 0xFFFF))	