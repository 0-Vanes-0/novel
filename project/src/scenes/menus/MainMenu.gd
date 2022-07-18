extends Control

onready var vBox := $VBoxContainer
onready var playButton := $VBoxContainer/PlayButton
onready var optionsButton := $VBoxContainer/OptionsButton
onready var quitButton := $VBoxContainer/QuitButton
onready var buttons := [playButton, optionsButton, quitButton]
onready var hasFocusButtons := false



func _ready() -> void:
	Preloader.loadEverything()
	get_viewport().connect("gui_focus_changed", self, "onFocusChanged")


func onFocusChanged(control : Control) -> void:
	hasFocusButtons = true


func _on_PlayButton_pressed() -> void:
	pass # Replace with function body.


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
	if(event.is_action("ui_cancel")):
		get_tree().quit(0)
	if(!hasFocusButtons and event.is_action("ui_down")):
		quitButton.grab_focus() # На самом деле будет выбрана playButton
	if(!hasFocusButtons and event.is_action("ui_up")):
		playButton.grab_focus() # На самом деле будет выбрана quitButton

















