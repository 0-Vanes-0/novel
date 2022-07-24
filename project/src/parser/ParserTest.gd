extends Node

var lexer := SceneLexer.new()
var parser := SceneParser.new()
var transpiler := SceneTranspiler.new()



func _ready() -> void:
	push_error("ssssssssssssssssssss")
	var text := lexer.read_file_content("res://src/parser/test-scene2.txt")
	# The token list
	var tokens: Array = lexer.tokenize(text)

#	print(tokens)

	# The syntax tree
	var tree: SceneParser.SyntaxTree = parser.parse(tokens)

	print(tree.values)

	# The finished .scene script
	var script: SceneTranspiler.DialogueTree = transpiler.transpile(tree, 0)
