require './classes/lexer.rb'
require './classes/parser.rb'

input = '{ "id": 1, "name": "thiago", "properties": { "isEnabled": true, "labels": ["Teste"], "teste": null, "age": $20 + 1$, "reportedHours": $1.9 + 10.3$ } }'
lexer = LexerJson.new(input)
tokens = lexer.tokenize
json = RecursiveDescentParserJson.new(tokens)
object = json.parse

puts "INPUT: #{input}"
puts "RUBY FORMAT: #{object}"
