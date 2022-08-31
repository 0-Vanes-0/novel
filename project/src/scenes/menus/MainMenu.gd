extends Control

onready var _loading_label := $LoadingLabel as Label
onready var _main_buttons := $MainButtons as Control
onready var _play_button := $MainButtons/VBoxContainer/PlayButton as Button
onready var _options_button := $MainButtons/VBoxContainer/OptionsButton as Button
onready var _quit_button := $MainButtons/VBoxContainer/QuitButton as Button
onready var _buttons := [_play_button, _options_button, _quit_button]
onready var _has_focus_buttons := false
#onready var _options_menu := $OptionsMenu as Control
#onready var _controls := $OptionsMenu/TabContainer/Controls as Tabs
#onready var _video := $OptionsMenu/TabContainer/Video as Tabs
#onready var _audio := $OptionsMenu/TabContainer/Audio as Tabs
#onready var _anim_player := $AnimationPlayer as AnimationPlayer



func _ready() -> void:
	get_viewport().connect("gui_focus_changed", self, "_on_focus_changed")
	
	_loading_label.visible = true
	_main_buttons.visible = false
	Preloader.load_everything()
	_loading_label.visible = false
	_main_buttons.visible = true


func _input(event: InputEvent) -> void:
	if not _has_focus_buttons and event.is_action_pressed(Config.BUTTONS.DOWN):
		_quit_button.grab_focus() # На самом деле будет выбрана _play_button
	if not _has_focus_buttons and event.is_action_pressed(Config.BUTTONS.UP):
		_play_button.grab_focus() # На самом деле будет выбрана _quit_button


#func _switch_to_Options():
#	_anim_player.play("show_options")
#	yield(_anim_player, "animation_finished")
#	$OptionsMenu/BackButton.grab_focus()


#func _switch_to_MainMenu():
#	_anim_player.play_backwards("show_options")
#	yield(_anim_player, "animation_finished")
#	_options_button.grab_focus()


func _on_focus_changed(control: Control) -> void:
	_has_focus_buttons = true


func _on_PlayButton_pressed() -> void:
	Config.settings["Audio"]["music_on"] = true
	Save.store_settings(Config.settings)
#	Global.set_player_variable("saved_scene", "anim(e)_test")
#	Global.set_player_variable("seeing_craig_first_time", true)
#	if not Global.get_player_variable("saved_scene"):
#		Global.set_player_variable("saved_scene", "empty_scene") #"empty_scene"
	get_tree().change_scene_to(Preloader.scene_controller)


func _on_OptionsButton_pressed() -> void:
#	_switch_to_Options()
	pass


func _on_QuitButton_pressed() -> void:
	get_tree().quit(0)


func _on_PlayButton_mouse_entered() -> void:
	_play_button.grab_focus()


func _on_OptionsButton_mouse_entered() -> void:
	_options_button.grab_focus()


func _on_QuitButton_mouse_entered() -> void:
	_quit_button.grab_focus()


func _on_BackButton_pressed() -> void:
#	_switch_to_MainMenu()
	pass

















