extends Node
# This is script which manages save files (player.dat and settings.cfg)

#onready var _PASSWORD := String("sexisamyth").sha256_buffer()
onready var _SAVE_FILES_PREFIX := OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
onready var _PLAYER_DATA_PATH := _SAVE_FILES_PREFIX.plus_file("Novelsaves/player.cfg")
onready var _SETTINGS_PATH := _SAVE_FILES_PREFIX.plus_file("Novelsaves/settings.cfg")



func store_variable(name: String, value): #-> Error
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_PLAYER_DATA_PATH)
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			err = _create_empty_file(_PLAYER_DATA_PATH)
			if err == OK:
				store_variable(name, value)
		else:
			Global.error("Error while opening file at %s, tried to store var, err = %s" 
				% [_PLAYER_DATA_PATH, Global.parse_error(err)])
	else:
		file.set_value("Variables", name, value)
		err = file.save(_PLAYER_DATA_PATH)
		if err != OK:
			Global.error("Error while saving file at %s, tried to store var, err = %s" 
					% [_PLAYER_DATA_PATH, Global.parse_error(err)])
	return err


func load_saved_variables() -> Dictionary:
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_PLAYER_DATA_PATH)
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			err = _create_empty_file(_PLAYER_DATA_PATH)
			if err == OK:
				return load_saved_variables()
		else:
			Global.error("Error while opening file at %s, tried to load vars, err = %s" 
				% [_PLAYER_DATA_PATH, Global.parse_error(err)])
		return {}
	
	var variables: Dictionary = {}
	for name in file.get_section_keys("Variables"):
		variables[name] = file.get_value("Variables", name)
	return variables


func store_settings(settings: Dictionary): #-> Error
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_SETTINGS_PATH)
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			err = _create_empty_file(_SETTINGS_PATH)
			if err == OK:
				store_settings(settings)
		else:
			Global.error("Error while opening file at %s, tried to store setting, err = %s" 
				% [_SETTINGS_PATH, Global.parse_error(err)])
	else:
		for section in settings.keys():
			for setting in settings[section].keys():
				file.set_value(section, setting, settings[section][setting])
		err = file.save(_SETTINGS_PATH)
		if err != OK:
			Global.error("Error while saving file at %s, tried to store setting, err = %s" 
					% [_SETTINGS_PATH, Global.parse_error(err)])
	return err


func load_settings() -> Dictionary:
	var file: ConfigFile = ConfigFile.new()
	var err = file.load(_SETTINGS_PATH)
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			err = _create_empty_file(_SETTINGS_PATH)
			if err == OK:
				return load_settings()
		else:
			Global.error("Error while opening file at %s, tried to load settings, err = %s" 
				% [_SETTINGS_PATH, Global.parse_error(err)])
		return {}
	
	var settings: Dictionary = {}
	for section in file.get_sections():
		settings[section] = {}
		for name in file.get_section_keys(section):
			settings[section][name] = file.get_value(section, name)
	return settings


func _create_empty_file(path: String):
	var err
	var file: File = File.new()
	var dir := Directory.new()
	err = dir.open(_SAVE_FILES_PREFIX)
	if err != OK:
		Global.error("Failed opening directory at '%s' on creating new file, ERR = %s" 
				%[_SAVE_FILES_PREFIX, Global.parse_error(err)])
	else:
		if not dir.dir_exists("Novelsaves"):
			err = dir.make_dir("Novelsaves")
			if err != OK:
				Global.error("Failed creating directory on creating new file, ERR = %s" 
						%[Global.parse_error(err)])
		else:
			err = file.open(path, File.WRITE)
			if err != OK:
				Global.error("Failed opening file at '%s' on creating new file, ERR = %s" 
						%[path, Global.parse_error(err)])
			else:
				Global.info(self, "Created empty file at %s" % path)
			file.close()
	return err
