load "TinyParser.rb"

parse = Parser.new("input5.tiny")
mytree = parse.program()
puts mytree.toStringList()
