class_name TextResource
extends Resource

export (String, MULTILINE) var _text := "#\n\n#"

func get_text() -> String:
	return _text
