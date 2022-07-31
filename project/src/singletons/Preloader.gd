extends Node
# This script is responsible for loading some resources like scenes as PackedScene,
# sprites, sounds and everything that can't be initialized through editor

const NARRATOR_ID := "narrator"

export (PackedScene) var main_menu: PackedScene
export (PackedScene) var scene_controller: PackedScene
export (PackedScene) var scene_player: PackedScene
export (PackedScene) var sound_player: PackedScene

export (String, DIR) var character_directory := ""
export (String, DIR) var novel_texts_directory := ""

export (Dictionary) var musics := { "test_music" : preload("res://assets/audios/music/Revashol Central.mp3") }
export (Dictionary) var sounds := { "test_sound" : preload("res://assets/audios/sfx/cat-muuaaw.wav") }
export (Dictionary) var backgrounds := { "no_background" : preload("res://assets/sprites/backgrounds/no_background.png") }

var _characters: Dictionary



func load_everything():
	if character_directory != "":
		_characters = _load_resources_with_type(character_directory, "_is_character")
	else:
		Global.error("Failed to load characters, character_directory is empty!")
	
	if main_menu == null:
		Global.error("Failed to load main_menu!")
	if scene_controller == null:
		Global.error("Failed to load scene_controller!")
	if scene_player == null:
		Global.error("Failed to load scene_player!")
	if sound_player == null:
		Global.error("Failed to load sound_player!")
	
	for music in musics.keys():
		if musics.get(music) == null:
			Global.error("Failed to load %s in musics, is null!" %[music])
	for sound in sounds.keys():
		if sounds.get(sound) == null:
			Global.error("Failed to load %s in sounds, is null!" %[sound])
	for background in backgrounds.keys():
		if backgrounds.get(background) == null:
			Global.error("Failed to load %s in backgrounds, is null!" %[background])


func load_resources(directory_path: String, extension: String = "tscn") -> Dictionary: # Key = filename, Value = file
	extension = "." + extension
	var files := {}
	var dir := Directory.new()
	if dir.open(directory_path) != OK:
		Global.error("Failed to dir.open() at %s " % [directory_path])
	if dir.list_dir_begin() != OK:
		Global.error("Failed to dir.list_dir_begin() at %s " % [directory_path])
	else:
		var filename := dir.get_next()
		while filename != "":
			if filename.ends_with(extension):
				filename = filename.substr(0, filename.find_last("."))
				files[filename] = load(directory_path.plus_file(filename))
			filename = dir.get_next()
		dir.list_dir_end()
	if files.empty():
		Global.error("Failed loading files: no \"%s\" found, path=%s" % [extension, directory_path])
	return files


func load_files_as_text(directory_path: String) -> Dictionary: # Key = filename, Value = file as String
	var files := {}
	var dir := Directory.new()
	if dir.open(directory_path) != OK:
		Global.error("Failed to dir.open() at %s " % [directory_path])
	if dir.list_dir_begin() != OK:
		Global.error("Failed to dir.list_dir_begin() at %s " % [directory_path])
	else:
		var file = File.new()
		var filename := dir.get_next()
		while filename != "":
			if file.open(directory_path.plus_file(filename), File.READ) == OK:
				filename = filename.substr(0, filename.find_last("."))
				files[filename] = file.get_as_text()
				file.close()
			filename = dir.get_next()
		dir.list_dir_end()
	if files.empty():
		Global.error("Failed loading files at path=%s" % [directory_path])
	return files


func _load_resources_with_type(directory_path: String, check_type_function: String) -> Dictionary:
	var resources := {}
	var dir := Directory.new()
	if dir.open(directory_path) != OK:
		Global.error("Failed to load type %s from %s" % [check_type_function, directory_path])
		return {}
	
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if filename.ends_with(".tres"):
			var resource: Resource = _load_res(directory_path.plus_file(filename))
			if not call(check_type_function, resource):
				continue
			resources[resource.id] = resource
			Global.info(self, "Loaded " + String(resource.id))
		filename = dir.get_next()
	dir.list_dir_end()
	
	return resources


func _load_res(path: String) -> Resource:
	var res = load(path)
	if res == null:
		Global.error("Res with path %s is null!" % path)
	return res


func _is_character(resource: Resource) -> bool:
	return resource is Character


func get_character(character_id: String) -> Character:
	return _characters.get(character_id)


func get_narrator() -> Character:
	return _characters.get(NARRATOR_ID)




























