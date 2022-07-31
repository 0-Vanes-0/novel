extends Node

var lexer := SceneLexer.new()
var parser := SceneParser.new()
var transpiler := SceneTranspiler.new()



func _ready() -> void:
	push_error("ssssssssssssssssssss")
	var text := lexer.read_file_content("res://assets/novel texts/test_chapter.txt")
	# The token list
	var tokens: Array = lexer.tokenize(text)

	Global.info(self, "%s" % [tokens])
	Global.info(self, "tokens size = %s" % [tokens.size()])

	# The syntax tree
	var tree: SceneParser.SyntaxTree = parser.parse(tokens)

	Global.info(self, tree.values)

	# The finished .scene script
	var script: SceneTranspiler.DialogueTree = transpiler.transpile("test_chapter", tree, 0)
