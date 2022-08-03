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


func load_resources(directory_path: String, extension: String = "tscn") -> Dictionary: # Key = filename, Value = file
	extension = "." + extension
	var files := {}
	var dir := Directory.new()
	if dir.open(directory_path) != OK:
		Global.error("Failed to dir.open() at %s " % [directory_path])
	else:
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


#func load_novel_texts() -> Dictionary:
#	var files := {}
#	if novel_texts_directory != "":
#		var file := File.new()
#		if file.open(novel_texts_directory.plus_file(LIST_FILE), File.READ) == OK:
#			var files_to_load := []
#			var line := file.get_line()
#			while line != "":
#				files_to_load.append(line)
#				line = file.get_line()
#			file.close()
#
#			for file_to_load in files_to_load:
#				if file.open(novel_texts_directory.plus_file("%s.txt" %[file_to_load]), File.READ) == OK:
#					files[file_to_load] = file.get_as_text()
#				file.close()
#		else:
#			Global.error("Failed to open %s at %s!" %[LIST_FILE, novel_texts_directory])
#	else:
#		Global.error("novel_texts_directory is empty!")
#
#	return files

#func load_files_as_text(directory_path: String) -> Dictionary: # Key = filename, Value = file as String
#	var files := {}
#	var dir := Directory.new()
#	var error = dir.open(directory_path)
#	if error != OK:
#		Global.error("Failed to dir.open() at %s, %s" % [directory_path, Global.parse_error(error)])
#	else:
#		error = dir.list_dir_begin()
#		if error != OK:
#			Global.error("Failed to dir.list_dir_begin() at %s " % [directory_path, Global.parse_error(error)])
#		else:
#			var file = File.new()
#			var filename := dir.get_next()
#			while filename != "":
#				if file.open(directory_path.plus_file(filename), File.READ) == OK:
#					filename = filename.substr(0, filename.find_last("."))
#					files[filename] = file.get_as_text()
#					file.close()
#				filename = dir.get_next()
#			dir.list_dir_end()
#	if files.empty():
#		Global.error("Failed loading files at path=%s" % [directory_path])
#	return files


#func _load_resources_with_type(directory_path: String, check_type_function: String) -> Dictionary:
#	var resources := {}
#	var dir := Directory.new()
#	if dir.open(directory_path) != OK:
#		Global.error("Failed to load type %s from %s" % [check_type_function, directory_path])
#		return {}
#
#	dir.list_dir_begin()
#	var filename = dir.get_next()
#	while filename != "":
#		if filename.ends_with(".tres"):
#			var resource: Resource = _load_res(directory_path.plus_file(filename))
#			if not call(check_type_function, resource):
#				continue
#			resources[resource.id] = resource
#			Global.info(self, "Loaded " + String(resource.id))
#		filename = dir.get_next()
#	dir.list_dir_end()
#
#	return resources


func _load_res(path: String) -> Resource:
	var res = load(path)
	if res == null:
		Global.error("Res with path %s is null!" % path)
	return res


func get_character(character_id: String) -> Character:
	return _characters.get(character_id)


func get_narrator() -> Character:
	return _characters.get(NARRATOR_ID)


func get_filename_from_path(path: String) -> String:
	var start := path.find_last("/") + 1
	var length := path.find_last(".") - start
	return path.substr(start, length)


























