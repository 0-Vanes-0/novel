extends Control

onready var loadingLabel := $LoadingLabel
onready var vBox := $VBoxContainer
onready var playButton := $VBoxContainer/PlayButton
onready var optionsButton := $VBoxContainer/OptionsButton
onready var quitButton := $VBoxContainer/QuitButton
onready var buttons := [playButton, optionsButton, quitButton]
onready var hasFocusButtons := false



func _ready() -> void:
	get_viewport().connect("gui_focus_changed", self, "onFocusChanged")
	loadingLabel.visible = true
	vBox.visible = false
	Preloader.call_deferred("loadEverything")
	Global.printInfo([self, yield(Preloader, "loadingDone_")]) # yield паузит этот код, пока не получит loadingDone_ от Preloader
	loadingLabel.visible = false
	vBox.visible = true
	$AudioStreamPlayer.play()


func onFocusChanged(control : Control) -> void:
	hasFocusButtons = true


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to(Preloader.sceneController)


func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.


func _on_QuitButton_pressed() -> void:
	get_tree().quit(0)


func _on_PlayButton_mouse_entered() -> void:
	playButton.grab_focus()


func _on_OptionsButton_mouse_entered() -> void:
	optionsButton.grab_focus()


func _on_QuitButton_mouse_entered() -> void:
	quitButton.grab_focus()


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		get_tree().quit(0)
	if(!hasFocusButtons and event.is_action_pressed("ui_down")):
		quitButton.grab_focus() # На самом деле будет выбрана playButton
	if(!hasFocusButtons and event.is_action_pressed("ui_up")):
		playButton.grab_focus() # На самом деле будет выбрана quitButton

















