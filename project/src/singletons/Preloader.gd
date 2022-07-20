extends Node

signal loadingDone_(text)

var mainMenu : PackedScene
var sceneController : PackedScene

var overwatchFontData : DynamicFontData
var pixelFontData : DynamicFontData

var soundPlayer : PackedScene
var testMusic : AudioStreamMP3
var testSound1 : AudioStream
var testSound2 : AudioStream
var testSound3 : AudioStream
var testSound4 : AudioStream



func loadEverything():
	mainMenu = preloadFrom("res://src/scenes/menus/MainMenu.tscn")
	sceneController = preloadFrom("res://src/scenes/SceneController.tscn")
	
	overwatchFontData = preloadFrom("res://assets/fonts/BigNoodleTitlingCyr.ttf")
	pixelFontData = preloadFrom("res://assets/fonts/KarmaSuture.ttf")
	
	soundPlayer = preloadFrom("res://src/objects/SoundPlayer.tscn")
	testMusic = preloadFrom("res://assets/audios/music/Revashol Central.mp3")
	testMusic.loop = true
	testMusic.loop_offset = 0.0
	testSound1 = preloadFrom("res://assets/audios/sfx/cat-maaaow.wav")
	testSound2 = preloadFrom("res://assets/audios/sfx/cat-angry-mreeow.wav")
	testSound3 = preloadFrom("res://assets/audios/sfx/cat-mrrr-louder.wav")
	testSound4 = preloadFrom("res://assets/audios/sfx/cat-muuaaw.wav")
	
	Config.fillConstants()
	emit_signal("loadingDone_", "Loading success!")


func preloadFrom(path : String) -> Resource:
	var res = load(path)
	if(res == null):
		Global.printError([self, "res with path ", path, " is null!"])
	return res


func loadScenes(path : String) -> Array:
	var scenes := []
	var dir := Directory.new()
	dir.open(path)
	if(dir.list_dir_begin() != OK):
		Global.printError([self, "dir.list_dir_begin() returned error!"])
	else:
		while(true):
			var file_name := dir.get_next()
			if(file_name == ""):
				break
			elif(file_name.ends_with(".tscn")):
				scenes.append(load(path + file_name))
		dir.list_dir_end()
	if(scenes.empty()):
		Global.printError([self, "Preload scenes failed: no 'tscn' found, path=", path])
	return scenes
