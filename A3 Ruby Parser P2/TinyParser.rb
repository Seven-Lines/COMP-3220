#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer
    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while (@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
            @errors_found += 1
        end
        consume()
    end

    def program()
        @errors_found = 0
        root = AST.new(Token.new("program", "program"))
        while (@lookahead.type != Token::EOF)
            root.addChild(statement())
        end
        puts "There were #{@errors_found} parse errors found."
        return root
    end

    def statement()
        # By default, create a simple 'statement' node that will be overridden
        stmt = AST.new(Token.new("statement", "statement"))
        if (@lookahead.type == Token::PRINT)
            stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
        return stmt
    end

    def assign()
        node = AST.new(Token.new("assignment","assignment"))
        if (@lookahead.type == Token::ID)
            id_node = AST.new(@lookahead)
            match(Token::ID)
            if (@lookahead.type == Token::ASSGN)
                node = AST.new(@lookahead) # '='
                match(Token::ASSGN)
                node.addChild(id_node)
                node.addChild(exp())
            else
                match(Token::ASSGN)
            end
        else
            match(Token::ID)
        end
        return node
    end

    def exp()
        left = term()
        return etail(left)
    end

    def etail(left)
        if (@lookahead.type == Token::ADDOP)
            op_node = AST.new(@lookahead)
            match(Token::ADDOP)
            right = term()
            op_node.addChild(left)
            op_node.addChild(right)
            return etail(op_node)
        elsif (@lookahead.type == Token::SUBOP)
            op_node = AST.new(@lookahead)
            match(Token::SUBOP)
            right = term()
            op_node.addChild(left)
            op_node.addChild(right)
            return etail(op_node)
        end
        return left
    end

    def term()
        left = factor()
        return ttail(left)
    end

    def ttail(left)
        if (@lookahead.type == Token::MULTOP)
            op_node = AST.new(@lookahead)
            match(Token::MULTOP)
            right = factor()
            op_node.addChild(left)
            op_node.addChild(right)
            return ttail(op_node)
        elsif (@lookahead.type == Token::DIVOP)
            op_node = AST.new(@lookahead)
            match(Token::DIVOP)
            right = factor()
            op_node.addChild(left)
            op_node.addChild(right)
            return ttail(op_node)
        end
        return left
    end

    def factor()
        # factor() must return an AST node for an int, id, or a parenthesized exp
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            node = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
                # Force match to consume an error
                match(Token::RPAREN)
            end
            return node
        elsif (@lookahead.type == Token::INT)
            node = AST.new(@lookahead)
            match(Token::INT)
            return node
        elsif (@lookahead.type == Token::ID)
            node = AST.new(@lookahead)
            match(Token::ID)
            return node
        else
            puts "Expected '(' or INT or ID, found #{@lookahead.text}"
            @errors_found += 1
            consume()  # skip the bad token
            return AST.new(Token.new("error","error"))
        end
    end
end
