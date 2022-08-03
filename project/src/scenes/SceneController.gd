class_name SceneController
extends Node2D

signal scene_loaded

const NOVEL_SCENES := []

var _current_index
var _current_scene: ScenePlayer

onready var scene_player_node := $ScenePlayerNode



func _ready() -> void:
	_load_scripts()
	var saved_scene_name: String = Global.get_player_variable("saved_scene")
	for i in range(NOVEL_SCENES.size()):
		if NOVEL_SCENES[i].name == saved_scene_name:
			playTextScene(i)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Config.BUTTONS.ESCAPE):
		get_tree().quit(0)
	if event.is_action_pressed(Config.BUTTONS.RESTART):
		_load_scripts()
		playTextScene(_current_index)


func _load_scripts():
	NOVEL_SCENES.clear()
	var _scripts: Dictionary = Preloader.novel_texts
	if not _scripts.empty():
		var lexer := SceneLexer.new()
		var parser := SceneParser.new()
		var transpiler := SceneTranspiler.new()
		
		var filenames := _scripts.keys()
		for filename in filenames:
			if filename == "" or _scripts.get(filename) == "":
				continue
			var tokens: Array = lexer.tokenize(_scripts.get(filename))
			var tree: SceneParser.SyntaxTree = parser.parse(tokens)
			var dialogue: SceneTranspiler.DialogueTree = transpiler.transpile(filename, tree, 0)
			if not dialogue.nodes[dialogue.index - 1] is SceneTranspiler.JumpCommandNode:
				(dialogue.nodes[dialogue.index - 1] as SceneTranspiler.BaseNode).next = -1
			NOVEL_SCENES.append(dialogue)
	else:
		Global.error("_scripts dictionary is empty!")


func playTextScene(index : int):
	for child in scene_player_node.get_children():
		child.queue_free()
	_current_index = int(clamp(index, 0, NOVEL_SCENES.size() - 1))
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = Preloader.scene_player.instance()
	scene_player_node.add_child(_current_scene, true)
	_current_scene.load_scene(NOVEL_SCENES[_current_index])
	_current_scene.connect("scene_finished", self, "_on_ScenePlayer_scene_finished")
	_current_scene.connect("restart_requested", self, "_on_ScenePlayer_restart_requested")
	_current_scene.run_scene()


func changeCurrentScene(scene : PackedScene):
	if scene == null:
		Global.error("Trying to change to null scene.")
	else:
		for child in scene_player_node.get_children():
			child.queue_free()
		var node = scene.instance()
		scene_player_node.add_child(node, true)
		yield(node, "ready")
		emit_signal("scene_loaded")
		Global.info(self, "Changed scene successfully!")


func _on_ScenePlayer_scene_finished() -> void:
	# If the scene that ended is the last scene, we're done playing the game.
	if _current_index == NOVEL_SCENES.size() - 1:
		return
	playTextScene(_current_index + 1)


func _on_ScenePlayer_restart_requested() -> void:
	playTextScene(_current_index)
