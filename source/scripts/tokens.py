# *************************************************************************************
# *************************************************************************************
#
#		Name : 		tokens.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Purpose : 	Token list/type generator.
#		Date :		7th February 2020
#
# *************************************************************************************
# *************************************************************************************

# *************************************************************************************
#
#								Tokens used in X16-Basic
#
# *************************************************************************************

class BasicTokens(object):
	def __init__(self):
		if BasicTokens.TOKENS is None:
			t = self.get().replace("\t"," ").upper().split("\n")			# preprocess
			t = [x if x.find("//") < 0 else x[:x.find("//")] for x in t]	# comments out
			t = (" ".join(t)).split()										# individual tokens
			current = None 													# current control byte value
			tokenID = 0x81
			tokens = { "(EOL)":{ "control":0,"id":0x80 }}					# add EOL as default
			for kw in t:
				if kw.startswith("[") or kw.endswith("]"):					# switch control byte
					current = self.getControl(kw[1:-1])
				else:														# add a new keyword
					assert kw not in tokens,"Duplicate "+kw					
					assert tokenID < 0xF8,"Out of tokens, shift needed"
					assert current is not None,"No control set"
					tokens[kw] = { "control":current,"id":tokenID }
					tokenID += 1
			for k in tokens.keys():											# store name in structure
				tokens[k]["keyword"] = k
			BasicTokens.TOKENS = tokens
	#
	#		Get the tokens
	#
	def getTokens(self):
		return BasicTokens.TOKENS
	#
	#		Convert group to control byte
	#
	def getControl(self,g):
		if g == "UNARY":
			return 0x40
		elif g == "CMD-":
			return 0x80
		elif g == "CMD":
			return 0x81
		elif g == "CMD+":
			return 0x82
		elif g == "SYNTAX":
			return 0x00
		if g >= "1" and g <= "7" and len(g) == 1:
			return int(g)+0x10
		assert "Bad group "+g
	#
	#		Return raw format.
	#
	def get(self):
		return """
//
//		****	WARNING : CHANGING ORDERS WILL KILL BINARY COMPATIBILITY 	****
//
[syntax]
		)	:	, 	;	#
//		Binary operators, lowest first
//	
[1] 	and or xor
[2]		> >= < <= = <>
[3] 	+ -
[4] 	* / mod
//
//		Unary functions
//
[unary]	
		len( 	rnd( 	asc( 	chr$(	val(	str$(	spc(
		left$(	mid$(	right$(	abs(	sgn(	int(	random(
		deek( 	peek(	vpeek( 	
		( % $
//
//		Structure Up/Down
//		
[cmd+]
		if repeat for while case
[cmd-]	 
		then endif until next endwhile endcase
[cmd]
		to step proc endproc call local run stop end print input when default let
		option list load save new old poke doke vpoke rem goto gosub sys return assert
		on open close dir dim read data restore

"""

BasicTokens.TOKENS = None

if __name__ == '__main__':
	t = BasicTokens()
	n = len(t.getTokens().keys())
	print("{0} tokens from $80-${1:02x}".format(n,n+0x80))
