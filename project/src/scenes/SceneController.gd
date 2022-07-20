class_name SceneController
extends Node2D

signal sceneLoaded_

onready var currScene := $CurrentScene



func _ready() -> void:
	pass


func changeCurrentScene(scene : PackedScene):
	if(!scene):
		Global.printError([self, "Trying to change to null scene."])
	else:
		for child in currScene.get_children():
			child.queue_free()
		var node := scene.instance()
		self.add_child(node, true)
		yield(node, "ready")
		emit_signal("sceneLoaded_")
