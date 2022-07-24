extends Node

signal loading_done(text)

var main_menu : PackedScene
var scene_controller : PackedScene
var text_scene : PackedScene

var sound_player : PackedScene
var test_music : AudioStreamMP3
var test_sound1 : AudioStream
var test_sound2 : AudioStream
var test_sound3 : AudioStream
var test_sound4 : AudioStream

var test_background : Texture



func load_everything():
	main_menu = _load_res("res://src/scenes/menus/MainMenu.tscn")
	scene_controller = _load_res("res://src/scenes/SceneController.tscn")
	text_scene = _load_res("res://src/scenes/MainScene.tscn")
	
	sound_player = _load_res("res://src/objects/SoundPlayer.tscn")
	test_music = _load_res("res://assets/audios/music/Revashol Central.mp3")
	test_music.loop = true
	test_music.loop_offset = 0.0
	test_sound1 = _load_res("res://assets/audios/sfx/cat-maaaow.wav")
	test_sound2 = _load_res("res://assets/audios/sfx/cat-angry-mreeow.wav")
	test_sound3 = _load_res("res://assets/audios/sfx/cat-mrrr-louder.wav")
	test_sound4 = _load_res("res://assets/audios/sfx/cat-muuaaw.wav")
	
	test_background = _load_res("res://assets/sprites/backgrounds/dani_bedroom.jpg")
	
	Config.fillConstants()
	emit_signal("loadingDone", "Loading success!")


func _load_res(path : String) -> Resource:
	var res = load(path)
	if res == null:
		Global.error([self, "res with path ", path, " is null!"])
	return res


func load_files(path : String, extension : String = "tscn") -> Array:
	extension = "." + extension
	var scenes := []
	var dir := Directory.new()
	dir.open(path)
	if dir.list_dir_begin() != OK:
		Global.error([self, "dir.list_dir_begin() returned error!"])
	else:
		while true:
			var file_name := dir.get_next()
			if file_name == "":
				break
			elif file_name.ends_with(extension):
				scenes.append(load(path + file_name))
		dir.list_dir_end()
	if scenes.empty():
		Global.error([self, "Preload scenes failed: no \"", extension, "\" found, path=", path])
	return scenes
