#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
	attr_accessor :type
	attr_accessor :text

# This is the only part of this class that you need to 
# modify.
	# Globals
	EOF = "eof"             # End of file
	WS = "whitespace"       # Whitespace 
	UNKWN = "unknown"       # Unknown token

	# Identifiers and Numbers
	IDENTIFIER = "id"       # Variable names 
	NUMBER = "int"          # Integer values 

	# Operators
	ASSIGN_OP = "="         # Assignment operator
	ADDOP = "+"            # Addition operator
	SUBOP = "-"            # Subtraction operator
	MULOP = "*"            # Multiplication operator
	DIVOP = "/"            # Division operator

	# Parentheses
	LPAREN = "("            # Left parenthesis
	RPAREN = ")"            # Right parenthesis

	# Keywords
	PRINT = "print"         # Print statement keyword

#constructor
	def initialize(type,text)
		@type = type
		@text = text
	end
	
	def get_type
		return @type
	end
	
	def get_text
		return @text
	end
	
# to string method
	def to_s
		return "#{@type} #{@text}"
	end
end