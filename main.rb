require './classes/lexer.rb'
require './classes/parser.rb'

input = "2 + 3 * (4 - 1)"
lexer = Lexer.new(input)
tokens = lexer.tokenize
parser = RecursiveDescentParser.new(tokens)
ast = parser.parse

puts "AST: #{ast.inspect}"
