class_name SceneController
extends Node2D

signal scene_loaded

onready var curr_scene := $CurrentScene



func _ready() -> void:
	pass


func change_current_scene(scene: PackedScene):
	if not scene:
		Global.error("Trying to change to null scene.")
	else:
		for child in curr_scene.get_children():
			child.queue_free()
		var node := scene.instance()
		self.add_child(node, true)
		yield(node, "ready")
		emit_signal("scene_loaded")
