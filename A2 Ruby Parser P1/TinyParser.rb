load "TinyToken.rb"
load "TinyLexer.rb"

class Parser < Lexer
  def initialize(filename)
    super(filename)
    @parse_errors = 0
    consume
  end

  def token_type_name(tt)
    case tt
    when Token::LPAREN then "LPAREN"
    when Token::RPAREN then "RPAREN"
    when Token::ADDOP  then "ADDOP"
    when Token::SUBOP  then "SUBOP"
    when Token::MULTOP then "MULTOP"
    when Token::DIVOP  then "DIVOP"
    when Token::ASSGN  then "ASSGN"
    when Token::PRINT  then "PRINT"
    when Token::ID     then "ID"
    when Token::INT    then "INT"
    when Token::IFOP   then "IFOP"
    when Token::THENOP then "THENOP"
    when Token::WHILEOP then "WHILEOP"
    when Token::ENDOP  then "ENDOP"
    when Token::LT     then "LT"
    when Token::GT     then "GT"
    when Token::ANDOP  then "ANDOP"
    else
      tt
    end
  end

  def consume
    @lookahead = nextToken
    while @lookahead.type == Token::WS
      @lookahead = nextToken
    end
  end

  def match(expected_type)
    if @lookahead.type == expected_type
      puts "Found #{token_type_name(expected_type)} Token: #{@lookahead.text}"
    else
      puts "Expected #{token_type_name(expected_type)} found #{@lookahead.text}"
      @parse_errors += 1
    end
    consume
  end

  def program
    puts "Entering STMTSEQ Rule"
    stmtseq
    puts "Exiting STMTSEQ Rule"
    puts "There were #{@parse_errors} parse errors found."
  end

  def stmtseq
    while @lookahead.type != Token::EOF
      puts "Entering STMT Rule"
      statement
      puts "Exiting STMT Rule"
    end
  end

  def statement
    if @lookahead.type == Token::PRINT
      match(Token::PRINT)
      puts "Entering EXP Rule"
      exp
      puts "Exiting EXP Rule"
    elsif @lookahead.type == Token::IFOP
      ifstmt
    elsif @lookahead.type == Token::WHILEOP
      loopstmt
    else
      puts "Entering ASSGN Rule"
      assign
      puts "Exiting ASSGN Rule"
    end
  end

  def ifstmt
    puts "Entering IFSTMT Rule"
    match(Token::IFOP)
    comparison
    match(Token::THENOP)
    puts "Entering STMTSEQ Rule"
    stmtseq_for_ifwhile
    puts "Exiting STMTSEQ Rule"
    match(Token::ENDOP)
    puts "Exiting IFSTMT Rule"
  end

  def loopstmt
    puts "Entering LOOPSTMT Rule"
    match(Token::WHILEOP)
    comparison
    match(Token::THENOP)
    puts "Entering STMTSEQ Rule"
    stmtseq_for_ifwhile
    puts "Exiting STMTSEQ Rule"
    match(Token::ENDOP)
    puts "Exiting LOOPSTMT Rule"
  end

  def stmtseq_for_ifwhile
    while @lookahead.type != Token::ENDOP && @lookahead.type != Token::EOF
      puts "Entering STMT Rule"
      statement
      puts "Exiting STMT Rule"
    end
  end

  def comparison
    puts "Entering COMPARISON Rule"
    factor
    if @lookahead.type == Token::LT
      match(Token::LT)
    elsif @lookahead.type == Token::GT
      match(Token::GT)
    elsif @lookahead.type == Token::ANDOP
      match(Token::ANDOP)
    else
      puts "Expected < or > or & found #{@lookahead.text}"
      @parse_errors += 1
      consume
    end
    factor
    puts "Exiting COMPARISON Rule"
  end

  def assign
    if @lookahead.type == Token::ID
      puts "Found ID Token: #{@lookahead.text}"
      consume
    else
      puts "Expected id found #{@lookahead.text}"
      @parse_errors += 1
      consume
    end

    if @lookahead.type == Token::ASSGN
      puts "Found ASSGN Token: #{@lookahead.text}"
      consume
    else
      puts "Expected = found #{@lookahead.text}"
      @parse_errors += 1
      consume
    end

    puts "Entering EXP Rule"
    exp
    puts "Exiting EXP Rule"
  end

  def exp
    term
    etail
  end

  def etail
    puts "Entering ETAIL Rule"
    if @lookahead.type == Token::ADDOP
      puts "Found ADDOP Token: #{@lookahead.text}"
      consume
      term
      etail
    elsif @lookahead.type == Token::SUBOP
      puts "Found SUBOP Token: #{@lookahead.text}"
      consume
      term
      etail
    else
      puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
    end
    puts "Exiting ETAIL Rule"
  end

  def term
    puts "Entering TERM Rule"
    factor
    ttail
    puts "Exiting TERM Rule"
  end

  def ttail
    puts "Entering TTAIL Rule"
    if @lookahead.type == Token::MULTOP
      puts "Found MULTOP Token: #{@lookahead.text}"
      consume
      factor
      ttail
    elsif @lookahead.type == Token::DIVOP
      puts "Found DIVOP Token: #{@lookahead.text}"
      consume
      factor
      ttail
    else
      puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
    end
    puts "Exiting TTAIL Rule"
  end

  def factor
    puts "Entering FACTOR Rule"
    if @lookahead.type == Token::LPAREN
      puts "Found LPAREN Token: #{@lookahead.text}"
      consume
      puts "Entering EXP Rule"
      exp
      puts "Exiting EXP Rule"
      if @lookahead.type == Token::RPAREN
        puts "Found RPAREN Token: #{@lookahead.text}"
        consume
      else
        puts "Expected ) found #{@lookahead.text}"
        @parse_errors += 1
        consume
      end
    elsif @lookahead.type == Token::ID
      puts "Found ID Token: #{@lookahead.text}"
      consume
    elsif @lookahead.type == Token::INT
      puts "Found INT Token: #{@lookahead.text}"
      consume
    else
      puts "Expected ( or INT or ID found #{@lookahead.text}"
      @parse_errors += 1
      consume
    end
    puts "Exiting FACTOR Rule"
  end
end
