class_name SceneController
extends Node2D

onready var _curr_scene := $CurrentScene

#const ScenePlayer := preload("res://src/scenes/ScenePlayer.tscn")

var _all_scenes: Dictionary = {} # String : SceneTranspiler.DialogueTree

var _current_scene_id := ""
var _scene_player: ScenePlayer

var lexer := SceneLexer.new()
var parser := SceneParser.new()
var transpiler := SceneTranspiler.new()



func _ready() -> void:
	VisualServer.set_default_clear_color(Color(0.1, 0.1, 0, 0.5))
	_load_scripts()
	_play_scene(Global.get_player_variable("saved_scene"))


func _load_scripts():
	_all_scenes.clear()
	_all_scenes = Preloader.novel_texts.duplicate()
	if not _all_scenes.keys().empty():
		for key in _all_scenes.keys():
			var script: String = _all_scenes.get(key)
			if script != null:
				var tokens: Array = lexer.tokenize(script)
				var tree: SceneParser.SyntaxTree = parser.parse(tokens)
				var dialogue: SceneTranspiler.DialogueTree = transpiler.transpile(tree, 0)
				
				# Make sure the scene is transitioned properly at the end of the script
				if not dialogue.nodes[dialogue.index - 1] is SceneTranspiler.JumpCommandNode:
					(dialogue.nodes[dialogue.index - 1] as SceneTranspiler.BaseNode).next = -1
				
				_all_scenes[key] = dialogue
			else:
				Global.error("Script with key %s is null!" %[key])
	else:
		Global.error("_all_scenes.keys().empty() returned true!!!")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Config.BUTTONS.ESCAPE):
		get_tree().quit(0)
	if event.is_action_pressed(Config.BUTTONS.RESTART):
		_load_scripts()
		_play_scene(_current_scene_id)


func _play_scene(scene_id: String) -> void:
	for child in _curr_scene.get_children():
		child.queue_free()
	
	if _all_scenes.has(scene_id):
		_scene_player = Preloader.scene_player.instance()
		_curr_scene.add_child(_scene_player)
		_scene_player.load_scene(_all_scenes[scene_id])
		_scene_player.connect("scene_finished", self, "_on_ScenePlayer_scene_finished")
		_scene_player.connect("restart_requested", self, "_on_ScenePlayer_restart_requested")
		_scene_player.run_scene()
		_current_scene_id = scene_id
	else:
		Global.error("Failed to play_scene(%s)!" %[scene_id])


func _on_ScenePlayer_scene_finished(next_scene_id: String) -> void:
	_play_scene(next_scene_id)


func _on_ScenePlayer_restart_requested() -> void:
	_play_scene(_current_scene_id)


#func change_current_scene(scene: PackedScene):
#	if not scene:
#		Global.error("Trying to change to null scene.")
#	else:
#		for child in _curr_scene.get_children():
#			child.queue_free()
#		var node := scene.instance()
#		self.add_child(node, true)
#		yield(node, "ready")
#		emit_signal("scene_loaded")
