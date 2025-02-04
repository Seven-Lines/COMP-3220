#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		begin
			# Need to modify this code so that the program
			# doesn't abend if it can't open the file but rather
			# displays an informative message
			@f = File.open(filename, 'r:utf-8')

			# Go ahead and read in the first character in the source
			# code file (if there is one) so that you can begin
			# lexing the source code file 
			@c = @f.eof? ? "eof" : @f.getc()

		rescue Errno::ENOENT  # Catches "file not found" errors
			puts "Error: File '#{filename}' not found. Please check the filename and try again."
			exit
		rescue StandardError => e  # Catch any other file-related errors
			puts "Error: An unexpected error occurred - #{e.message}"
			exit
		end
	end

	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			return Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str =""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
		
			tok = Token.new(Token::WS,str)
			return tok

		elsif letter?(@c)  # Handle Identifiers and Keywords
			str = ""
			while letter?(@c) || numeric?(@c)  # ALPHA+
				str += @c
				nextCh()
			end
			# Check if it's the "print" keyword or an identifier
			if str == "print"
				return Token.new(Token::PRINT, str)
			else
				return Token.new(Token::IDENTIFIER, str)
			end
	
		elsif numeric?(@c)  # Handle Numbers (INT)
			str = ""
			while numeric?(@c)
				str += @c
				nextCh()
			end
			return Token.new(Token::NUMBER, str)
	
		elsif @c == "="  # Handle Assignment Operator
			nextCh()
			return Token.new(Token::ASSIGN_OP, "=")
	
		elsif @c == "+"  # Handle Addition Operator
			nextCh()
			return Token.new(Token::ADDOP, "+")
	
		elsif @c == "-"  # Handle Subtraction Operator
			nextCh()
			return Token.new(Token::SUBOP, "-")
	
		elsif @c == "*"  # Handle Multiplication Operator
			nextCh()
			return Token.new(Token::MULOP, "*")
	
		elsif @c == "/"  # Handle Division Operator
			nextCh()
			return Token.new(Token::DIVOP, "/")
	
		elsif @c == "("  # Handle Left Parenthesis
			nextCh()
			return Token.new(Token::LPAREN, "(")
	
		elsif @c == ")"  # Handle Right Parenthesis
			nextCh()
			return Token.new(Token::RPAREN, ")")

		elsif @c == "<"  # Handle Less Than Operator
			nextCh()
			return Token.new(Token::LT_OP, "<")
	  
		  elsif @c == ">"  # Handle Greater Than Operator
			nextCh()
			return Token.new(Token::GT_OP, ">")
	  
		  elsif @c == "&"  # Handle And Operator
			nextCh()
			return Token.new(Token::AND_OP, "&")

		else  # Handle Unknown Token
			tok = Token.new(Token::UNKWN, @c)
			nextCh()
			return tok
		end

		# elsif ...
		# more code needed here! complete the code here 
		# so that your scanner can correctly recognize,
		# print (to a text file), and display all tokens
		# in our grammar that we found in the source code file
		
		# FYI: You don't HAVE to just stick to if statements
		# any type of selection statement "could" work. We just need
		# to be able to programatically identify tokens that we 
		# encounter in our source code file.
		
		# don't want to give back nil token!
		# remember to include some case to handle
		# unknown or unrecognized tokens.
		# below is an example of how you "could"
		# create an "unknown" token directly from 
		# this scanner. You could also choose to define
		# this "type" of token in your token class

	end
end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end