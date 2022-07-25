extends Node
# This is script which manages save files (player.dat and settings.cfg)

signal saving_done(err)

const _PASSWORD := "sexisamyth"
const _SAVE_FILES_PREFIX := "res://" #"user://"
const _PLAYER_DATA_PATH := _SAVE_FILES_PREFIX + "saves/player.dat"
const _SETTINGS_PATH := _SAVE_FILES_PREFIX + "saves/settings.cfg"



func store_variable(name: String, value):
	var file: ConfigFile = ConfigFile.new()
	var err = file.load_encrypted_pass(_PLAYER_DATA_PATH, _PASSWORD)
	if err != OK:
		Global.error("Error while opening file at %s, err = %s" % [_PLAYER_DATA_PATH, Global.parse_error(err)])
		if err == ERR_FILE_NOT_FOUND:
			_create_empty_file(_PLAYER_DATA_PATH)
			store_variable(name, value)
	
	file.set_value("Variables", name, value)
	err = file.save_encrypted_pass(_PLAYER_DATA_PATH, _PASSWORD)
	if err != OK:
		Global.error("Error while saving file at %s, err = %s" % [_PLAYER_DATA_PATH, Global.parse_error(err)])
	emit_signal("saving_done", err)


func load_saved_variables() -> Dictionary:
	var file: ConfigFile = ConfigFile.new()
	var err = file.load_encrypted_pass(_PLAYER_DATA_PATH, _PASSWORD)
	if err != OK:
		Global.error("Error while opening file at %s, err = %s" % [_PLAYER_DATA_PATH, Global.parse_error(err)])
		if err == ERR_FILE_NOT_FOUND:
			_create_empty_file(_PLAYER_DATA_PATH)
		return {}
	
	var variables: Dictionary = {}
	for name in file.get_section_keys("Variables"):
		variables[name] = file.get_value("Variables", name)
	return variables


func store_settings(settings: Dictionary):
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_SETTINGS_PATH)
	if err != OK:
		Global.error("Error while opening file at %s, err = %s" % [_SETTINGS_PATH, Global.parse_error(err)])
		if err == ERR_FILE_NOT_FOUND:
			_create_empty_file(_SETTINGS_PATH)
			store_settings(settings)
	
	for section in settings.keys():
		for setting in settings[section].keys():
			file.set_value(section, setting, settings[section][setting])
	err = file.save(_SETTINGS_PATH)
	if err != OK:
		Global.error("Error while saving file at %s, err = %s" % [_SETTINGS_PATH, Global.parse_error(err)])
	emit_signal("saving_done", err)


func load_settings() -> Dictionary:
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_SETTINGS_PATH)
	if err != OK:
		Global.error("Error while opening file at %s, err = %s" % [_SETTINGS_PATH, Global.parse_error(err)])
		if err == ERR_FILE_NOT_FOUND:
			_create_empty_file(_SETTINGS_PATH)
		return {}
	
	var settings: Dictionary = {}
	for section in file.get_sections():
		settings[section] = {}
		for name in file.get_section_keys(section):
			settings[section][name] = file.get_value(section, name)
	return settings


func _create_empty_file(path: String):
	var file: File = File.new()
	var dir := Directory.new()
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	file.open(path, File.WRITE)
	file.close()
	Global.info(self, "Created empty file at %s" % path)

















