require './classes/token.rb'

class LexerMath
  def initialize(input)
    @input = input
    @position = 0
  end

  def tokenize
    tokens = []
    while current_char
      case current_char
      when /\s/
        advance
      when /\d/
        tokens << number
      when '+'
        tokens << Token.new(:PLUS, '+')
        advance
      when '-'
        tokens << Token.new(:MINUS, '-')
        advance
      when '*'
        tokens << Token.new(:MUL, '*')
        advance
      when '/'
        tokens << Token.new(:DIV, '/')
        advance
      when '^'
        tokens << Token.new(:POW, '^')
        advance
      when '('
        tokens << Token.new(:LPAREN, '(')
        advance
      when ')'
        tokens << Token.new(:RPAREN, ')')
        advance
      else
        raise "Unexpected character: #{current_char}"
      end
    end
    tokens
  end

  private

  def current_char
    return @input[@position]
  end

  def advance
    @position += 1
  end

  def number
    start = @position
    advance while current_char =~ /\d|\./
    return Token.new(:NUMBER, @input[start...@position].to_f)
  end
end

class LexerJson
  def initialize(input)
    @input = input
    @position = 0
  end

  def tokenize
    tokens = []
    while current_char
      case current_char
      when /"/
        tokens << string
      when /\s/
        advance
      when '$'
        tokens << math
      when /\d/
        tokens << number
      when 't'
        tokens << boolean
      when 'f'
        tokens << boolean
      when 'n'
        tokens << null
      when ','
        tokens << Token.new(:COMMA, ',')
        advance
      when ':'
        tokens << Token.new(:COLON, ':')
        advance
      when '{'
        tokens << Token.new(:LBRACE, '{')
        advance
      when '}'
        tokens << Token.new(:RBRACE, '}')
        advance
      when '['
        tokens << Token.new(:LBRACKET, '[')
        advance
      when ']'
        tokens << Token.new(:RBRACKET, ']')
        advance
      else
        raise "Unexpected character: #{current_char} (Position: #{@position})"
      end
    end
    return tokens
  end

  private

  def current_char
    @input[@position]
  end

  def advance
    @position += 1
  end

  def math
    advance
    start = @position
    advance while current_char != '$'
    advance
    return Token.new(:MATH, @input[start...@position-1])
  end

  def string
    advance
    start = @position
    advance while current_char != '"'
    advance
    return Token.new(:STRING, @input[start...@position-1])
  end

  def boolean
    start = @position
    advance while current_char != 'e'
    advance
    return Token.new(:BOOLEAN, @input[start...@position] == 'true')
  end

  def null
    advance while current_char != 'l'
    advance
    advance
    return Token.new(:NULL, nil)
  end

  def number
    start = @position
    advance while current_char =~ /\d|\./
    return Token.new(:NUMBER, @input[start...@position].to_f)
  end
end

