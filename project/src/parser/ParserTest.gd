extends Node

var lexer := SceneLexer.new()
var parser := SceneParser.new()
var transpiler := SceneTranspiler.new()



func _ready() -> void:
	print("Started ParserTest")
	var text := (load("res://assets/novel_texts/test_chapter.tres") as TextResource).get_text()
	# The token list
	var tokens: Array = lexer.tokenize(text)

	Global.info(self, "Printing tokens")
	Global.print_arr(tokens)
	Global.info(self, "tokens size = %s" % [tokens.size()])

	# The syntax tree
	var tree: SceneParser.SyntaxTree = parser.parse(tokens)

#	Global.info(self, "Printing SyntaxTree values")
#	Global.print_arr(tokens)

	# The finished .scene script
	var script: SceneTranspiler.DialogueTree = transpiler.transpile("test_chapter", tree, 0)
