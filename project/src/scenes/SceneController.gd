class_name SceneController
extends Node2D

signal scene_loaded

const NOVEL_SCENES := []

export (String) var NOVEL_TEXTS_PATH

var _scripts : Array
var _current_index
var _current_scene : ScenePlayer

onready var scene_player_node := $ScenePlayerNode



func _ready() -> void:
	if not _scripts.empty():
		var lexer := SceneLexer.new()
		var parser := SceneParser.new()
		var transpiler := SceneTranspiler.new()
		
		for script in _scripts:
			var text := lexer.read_file_content(script)
			var tokens : Array = lexer.tokenize(text)
			var tree : SceneParser.SyntaxTree = parser.parse(tokens)
			var dialogue : SceneTranspiler.DialogueTree = transpiler.transpile(tree, 0)
			if not dialogue.nodes[dialogue.index - 1] is SceneTranspiler.JumpCommandNode:
				(dialogue.nodes[dialogue.index - 1] as SceneTranspiler.BaseNode).next = -1
			NOVEL_SCENES.append(dialogue)
		
		playTextScene(0) # ПОТОМ ТОЧНО НЕ 0
	else:
		Global.error([self, "loadNovelScripts() returned empty array"])
	changeCurrentScene(Preloader.text_scene) #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Config.BUTTONS.ESCAPE):
		get_tree().quit(0)
#	if event.is_action_pressed(Config.BUTTONS.DOWN):
#		changeCurrentScene(Preloader.text_scene)


func playTextScene(index : int):
	_current_index = int(clamp(index, 0, NOVEL_SCENES.size() - 1))
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = ScenePlayer.new()
	scene_player_node.add_child(_current_scene)
	# currentTextScene --> запуск всего и вся
#	.load_scene(SCENES[_current_index])
#	.connect("scene_finished", self, "_on_ScenePlayer_scene_finished")
#	.connect("restart_requested", self, "_on_ScenePlayer_restart_requested")
#	.run_scene()


func loadNovelScripts() -> Array:
	var array = []
	Preloader.load_files(NOVEL_TEXTS_PATH, "txt")
	return array


func changeCurrentScene(scene : PackedScene):
	if scene == null:
		Global.error([self, "Trying to change to null scene."])
	else:
		for child in scene_player_node.get_children():
			child.queue_free()
		var node = scene.instance()
		scene_player_node.add_child(node, true)
		yield(node, "ready")
		emit_signal("sceneLoaded_")
		Global.info([self, "Changed scene successfully!"])


func _on_ScenePlayer_scene_finished() -> void:
	# If the scene that ended is the last scene, we're done playing the game.
	if _current_index == NOVEL_SCENES.size() - 1:
		return
	playTextScene(_current_index + 1)


func _on_ScenePlayer_restart_requested() -> void:
	playTextScene(_current_index)
