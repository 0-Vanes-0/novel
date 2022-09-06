extends Node
# This is script which stores constant variables, player's settings and other constant stuff

# ---------- CONSTANTS ----------

const BUTTONS := {
	UP = "ui_up",
	DOWN = "ui_down",
	LEFT = "ui_left",
	RIGHT = "ui_right",
	ACCEPT = "ui_accept",
	LMB = "ui_select",
	ESCAPE = "ui_cancel",
	RESTART = "ui_home",
}
const DEFAULT_SETTINGS := {
	"Video" : {
		"fullscreen" : false,
	},
	"Audio" : {
		"music_on" : true,
	},
	"Interface" : {
		"text_speed" : 1.0,
	},
}

var settings: Dictionary

# ---------- FUNTIONS ----------

func _ready() -> void:
	settings = Save.load_settings()
	if settings.empty():
		settings = DEFAULT_SETTINGS.duplicate(true)
		Global.info(self, "Saving NEW settings done! Retuned %s" 
				%[Global.parse_error(Save.store_settings(settings))])
	Global.info(self, "Current settings " + String(settings))


func set_settings(settings: Dictionary):
	Global.info(self, "Saving settings done! Retuned %s" 
			%[Global.parse_error(Save.store_settings(settings))])
	settings = Save.load_settings()


func get_setting(section: String, name: String): # -> Variant
	if settings.has(section):
		if settings[section].has(name):
			return settings[section][name]
	return null
