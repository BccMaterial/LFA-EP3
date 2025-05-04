require './classes/token.rb'

class RecursiveDescentParserMath
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    return expr
  end

  private

  def current_token
    return @tokens[@position]
  end

  def eat(expected_type)
    if current_token&.type == expected_type
      token = current_token
      @position += 1
      return token
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
    return node
  end

  def term
    node = power
    while current_token&.type == :MUL || current_token&.type == :DIV
      op = eat(current_token.type)
      node = [op.type, node, power]
    end
    return node
  end

  def power
    node = factor
    while current_token&.type == :POW
      op = eat(current_token.type)
      node = [op.type, node, factor]
    end
    return node
  end

  def factor
    if current_token.type == :NUMBER
      eat(:NUMBER).value
    elsif current_token.type == :LPAREN
      eat(:LPAREN)
      result = expr
      eat(:RPAREN)
      return result
    else
      raise "Unexpected token in factor: #{current_token}"
    end
  end
end

class RecursiveDescentParserJson
  # Vem primeiro: Primitivo, Lista ou Objeto
  # Dentro de objeto:
  #   Vem primeiro: STRING
  #   Vem segundo: COLON
  #   Vem terceiro: Primitivo
  #   Vem quarto: COMMA
  # Dentro de lista:
  #   Vem primeiro: Primitivo
  #   Vem segundo: COMMA
  #   Vem terceiro: Primitivo
  #   .
  #   .
  #   .
  #   Vem último: RBRACKET
   
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    return expr
  end

  private

  def current_token
    return @tokens[@position]
  end

  def eat(expected_type)
    if current_token&.type == expected_type
      token = current_token
      @position += 1
      return token
    else
      raise "Unexpected token: #{current_token}, expected #{expected_type}"
    end
  end

  def list
  end

  def item
  end

  def object
  end

  def field
  end

  def factor
    if current_token.type in [:STRING, :BOOLEAN, :NULL, :NUMBER, :MATH]
      eat(current_token.type).value
    elsif current_token.type == :LBRACE
      eat(:LBRACE)
      result = expr
      eat(:RBRACE)
      return result
    elsif current_token.type == :LBRACKET
      eat(:LBRACKET)
      result = expr
      eat(:RBRACKET)
      return result
    else
      raise "Unexpected token in factor: #{current_token}"
    end
  end
end
