require './classes/token.rb'

class RecursiveDescentParserMath
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    return expr
  end

  def evaluate
    ast = parse  # Gera a AST (Abstract Syntax Tree)
    calculate(ast)  # Calcula o resultado
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

  def calculate(node)
    if node.is_a?(Numeric)  # Se for um número, retorna direto
      node
    elsif node.is_a?(Array)  # Se for uma operação, resolve recursivamente
      left = calculate(node[1])
      right = calculate(node[2])

      case node[0]
      when :PLUS then left + right
      when :MINUS then left - right
      when :MUL then left * right
      when :DIV then left / right
      when :POW then left ** right
      else
        raise "Unknown operator: #{node[:op]}"
      end
    else
      raise "Invalid node: #{node}"
    end
  end
end

class RecursiveDescentParserJson
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def parse
    json_value
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

  def json_value
    case current_token&.type
    when :LBRACE then json_object
    when :LBRACKET then json_array
    when :STRING, :NUMBER, :BOOLEAN, :NULL, :MATH then primitive_value
    else
      raise "Unexpected token in json_value: #{current_token}"
    end
  end

  def json_object
    eat(:LBRACE)
    obj = {}

    # Objeto vazio
    if current_token&.type == :RBRACE
      eat(:RBRACE)
      return obj
    end

    # Primeiro campo
    key = eat(:STRING).value
    eat(:COLON)
    value = json_value
    obj[key] = value

    # Próximos campos
    while current_token&.type == :COMMA
      eat(:COMMA)
      key = eat(:STRING).value
      eat(:COLON)
      value = json_value
      obj[key] = value
    end

    eat(:RBRACE)
    obj
  end

  def json_array
    eat(:LBRACKET)
    arr = []

    # Array vazio
    if current_token&.type == :RBRACKET
      eat(:RBRACKET)
      return arr
    end

    # Primeiro elemento
    arr << json_value

    # Elementos restantes
    while current_token&.type == :COMMA
      eat(:COMMA)
      arr << json_value
    end

    eat(:RBRACKET)
    arr
  end

  def primitive_value
    case current_token&.type
    when :STRING then eat(:STRING).value
    when :NUMBER then eat(:NUMBER).value
    when :BOOLEAN then eat(:BOOLEAN).value == 'true'
    when :NULL then eat(:NULL); nil
    when :MATH
      math_expr = eat(:MATH).value
      math_tokens = LexerMath.new(math_expr).tokenize
      math_parser = RecursiveDescentParserMath.new(math_tokens)
      math_parser.evaluate
    else
      raise "Unexpected primitive value: #{current_token}"
    end
  end
end
