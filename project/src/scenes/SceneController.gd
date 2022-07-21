class_name SceneController
extends Node2D

signal sceneLoaded_

onready var currScene := $CurrentScene



func _ready() -> void:
	changeCurrentScene(Preloader.mainScene)


func changeCurrentScene(scene : PackedScene):
	if(!scene):
		Global.printError([self, "Trying to change to null scene."])
	else:
		for child in currScene.get_children():
			child.queue_free()
		var node = scene.instance()
		currScene.add_child(node, true)
		yield(node, "ready")
		emit_signal("sceneLoaded_")
		Global.printInfo([self, "Changed scene successfully!"])


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		get_tree().quit(0)
	if(event.is_action_pressed("ui_down")):
		changeCurrentScene(Preloader.mainScene)
