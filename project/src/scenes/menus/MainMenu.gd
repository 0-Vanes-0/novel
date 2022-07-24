extends Control

onready var loading_label := $LoadingLabel as Label
onready var v_box := $VBoxContainer as VBoxContainer
onready var play_button := $VBoxContainer/PlayButton as Button
onready var options_button := $VBoxContainer/OptionsButton as Button
onready var quit_button := $VBoxContainer/QuitButton as Button
onready var buttons := [play_button, options_button, quit_button]
onready var has_focus_buttons := false



func _ready() -> void:
	get_viewport().connect("gui_focus_changed", self, "on_focus_changed")
	loading_label.visible = true
	v_box.visible = false
	Preloader.call_deferred("load_everything")
	Global.info(self, yield(Preloader, "loading_done")) # yield паузит этот код, пока не получит loadingDone_ от Preloader
	loading_label.visible = false
	v_box.visible = true
	$AudioStreamPlayer.play()
	
	#Global.get_player_variable
	#Global.set_player_variable
	Save.store_setting("Audio", "smth", true)
	Save.store_variable("lol", 123)
	yield(get_tree().create_timer(2.0), "timeout")
	Global.info(self, String(Save.load_saved_variables()))
	Global.info(self, String(Save.load_settings()))


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed(Config.BUTTONS.ESCAPE)):
		get_tree().quit(0)
	if not has_focus_buttons and event.is_action_pressed(Config.BUTTONS.DOWN):
		quit_button.grab_focus() # На самом деле будет выбрана play_button
	if not has_focus_buttons and event.is_action_pressed(Config.BUTTONS.UP):
		play_button.grab_focus() # На самом деле будет выбрана quit_button


func on_focus_changed(control : Control) -> void:
	has_focus_buttons = true


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to(Preloader.scene_controller)


func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.


func _on_QuitButton_pressed() -> void:
	get_tree().quit(0)


func _on_PlayButton_mouse_entered() -> void:
	play_button.grab_focus()


func _on_OptionsButton_mouse_entered() -> void:
	options_button.grab_focus()


func _on_QuitButton_mouse_entered() -> void:
	quit_button.grab_focus()


















