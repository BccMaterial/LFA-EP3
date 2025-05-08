require './classes/lexer.rb'
require './classes/parser.rb'

input = File.read('input.json')
lexer = LexerJson.new(input)
tokens = lexer.tokenize
json = RecursiveDescentParserJson.new(tokens)
object = json.parse

puts "INPUT: #{input}"
puts "RUBY FORMAT: #{object}"
