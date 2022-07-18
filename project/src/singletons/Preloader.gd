extends Node

var mainMenuScene : PackedScene

var overwatchFontData : DynamicFontData
var pixelFontData : DynamicFontData
var buttonFont : DynamicFont



func loadEverything():
	mainMenuScene = preloadFrom("res://src/scenes/menus/MainMenu.tscn")
	
	overwatchFontData = preloadFrom("res://assets/fonts/BigNoodleTitlingCyr.ttf")
	pixelFontData = preloadFrom("res://assets/fonts/KarmaSuture.ttf")
	buttonFont = DynamicFont.new()
	buttonFont.font_data = overwatchFontData
	buttonFont.size = 40
#	buttonFont.extra_spacing_top = Global.buttonHeight / 10.0
	
	Config.fillConstants()


func preloadFrom(path : String) -> Resource:
	var res = load(path)
	if(res == null):
		Global.printInfo([self, "res with path ", path, " is null!"])
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
