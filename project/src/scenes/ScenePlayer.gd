class_name ScenePlayer
extends Control

signal scene_finished
signal restart_requested
signal transition_finished

const KEY_END_OF_SCENE := -1
const KEY_RESTART_SCENE := -2

const TRANSITIONS := {
	fade_in = "appear_async",
	fade_out = "disappear_async",
}

var _scene_data := {}

onready var background := $Background
onready var text_box := $TextBox
onready var ch_displayer := $CharacterDisplayer
onready var anim_player := $AnimationPlayer



func load_scene(dialogue: SceneTranspiler.DialogueTree) -> void:
	# The main script
	_scene_data = dialogue.nodes


func run_scene():
	var key = 0
	while key != KEY_END_OF_SCENE:
		var node: SceneTranspiler.BaseNode = _scene_data[key]
		break
