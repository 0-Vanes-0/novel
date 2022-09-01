class_name TextResource
extends Resource

export (String, MULTILINE) var text := "#\n\n#"

func get_text() -> String:
	return text
