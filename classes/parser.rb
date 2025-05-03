require './classes/token.rb'

class RecursiveDescentParser
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    expr
  end

  private

  def current_token
    @tokens[@position]
  end

  def eat(expected_type)
    if current_token&.type == expected_type
      token = current_token
      @position += 1
      token
    else
      raise "Unexpected token: #{current_token}, expected #{expected_type}"
    end
  end

  def expr
    node = term
    while current_token&.type == :PLUS || current_token&.type == :MINUS
      op = eat(current_token.type)
      node = [op.type, node, term]
    end
    node
  end

  def term
    node = factor
    while current_token&.type == :MUL || current_token&.type == :DIV
      op = eat(current_token.type)
      node = [op.type, node, factor]
    end
    node
  end

  def factor
    if current_token.type == :NUMBER
      eat(:NUMBER).value
    elsif current_token.type == :LPAREN
      eat(:LPAREN)
      result = expr
      eat(:RPAREN)
      result
    else
      raise "Unexpected token in factor: #{current_token}"
    end
  end
end
