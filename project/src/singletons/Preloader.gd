extends Node
# This script is responsible for loading some resources like scenes as PackedScene,
# sprites, sounds and everything that can't be initialized through editor

const NARRATOR_ID := "narrator"

export (PackedScene) var main_menu: PackedScene
export (PackedScene) var scene_controller: PackedScene
export (PackedScene) var scene_player: PackedScene
export (PackedScene) var sound_player: PackedScene

export (Array, Resource) var text_resources := []
export (Array, Resource) var character_resources := []
export (Array, AudioStreamMP3) var music_resources := []
export (Array, AudioStream) var sound_resources := []
export (Array, Texture) var background_resources := []

var novel_texts: Dictionary = {}
var _characters: Dictionary = {}
var musics: Dictionary = {}
var sounds: Dictionary = {}
var backgrounds: Dictionary = {}



func load_everything():
	if main_menu == null:
		Global.error("Failed to load main_menu!")
	if scene_controller == null:
		Global.error("Failed to load scene_controller!")
	if scene_player == null:
		Global.error("Failed to load scene_player!")
	if sound_player == null:
		Global.error("Failed to load sound_player!")
	
	for res in text_resources:
		if res == null or not res is TextResource:
			Global.error("Failed to load novel text!")
		else:
			novel_texts[get_filename_from_path(res.resource_path)] = res.get_text()
	for res in character_resources:
		if res == null or not res is Character:
			Global.error("Failed to load character!")
		else:
			_characters[res.id] = res
	for res in music_resources:
		if res == null:
			Global.error("Failed to load music!")
		else:
			musics[get_filename_from_path(res.resource_path)] = res
	for res in sound_resources:
		if res == null:
			Global.error("Failed to load sound!")
		else:
			sounds[get_filename_from_path(res.resource_path)] = res
	for res in background_resources:
		if res == null:
			Global.error("Failed to load background!")
		else:
			backgrounds[get_filename_from_path(res.resource_path)] = res
	
#	Global.info(self, "Loaded novel_texts: " + String(novel_texts))
#	Global.info(self, "Loaded _characters: " + String(_characters))
#	Global.info(self, "Loaded musics: " + String(musics))
#	Global.info(self, "Loaded sounds: " + String(sounds))
#	Global.info(self, "Loaded backgrounds: " + String(backgrounds))


func _load_res(path : String) -> Resource:
	var res = load(path)
	if res == null:
		Global.error("res with path " + path + " is null!")
	return res


func load_scenes(path : String) -> Array:
	var scenes := []
	var dir := Directory.new()
	var err = dir.open(path)
	if err != OK:
		Global.error("dir.open(path) returned error: " + Global.parse_error(err))
	else:
		err = dir.list_dir_begin()
		if err != OK:
			Global.error("dir.list_dir_begin() returned error: " + Global.parse_error(err))
		else:
			while true:
				var file_name := dir.get_next()
				if file_name == "":
					break
				elif file_name.ends_with(".tscn"):
					scenes.append(load(path + file_name))
			dir.list_dir_end()
	if scenes.empty():
		Global.error("Preload scenes failed: no 'tscn' found, path=" + path)
	return scenes


func get_character(character_id: String) -> Character:
	return _characters.get(character_id)


func get_narrator() -> Character:
	return _characters.get(NARRATOR_ID)


func get_filename_from_path(path: String) -> String:
	var start := path.find_last("/") + 1
	var length := path.find_last(".") - start
	return path.substr(start, length)
