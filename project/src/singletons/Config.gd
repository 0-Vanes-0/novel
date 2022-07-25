extends Node
# This is script which stores constant variables, player's settings and other constant stuff

# ---------- CONSTANTS ----------

const BUTTONS := {
	UP = "ui_up",
	DOWN = "ui_down",
	LEFT = "ui_left",
	RIGHT = "ui_right",
	ENTER = "ui_accept",
	ESCAPE = "ui_cancel",
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
		Save.call_deferred("store_settings", settings)
		Global.info(self, "Saving settings done! Retuned %s" % [yield(Save, "saving_done")])
	Global.info(self, String(settings))


func set_settings(settings: Dictionary):
	Save.call_deferred("store_settings", settings)
	Global.info(self, "Saving settings done! Retuned %s" % [yield(Save, "saving_done")])
	settings = Save.load_settings()


func get_setting(section: String, name: String): # -> Variant
	return settings[section][name]
