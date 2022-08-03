## Data container for characters
class_name Character
extends Resource

export var id := "character_id"
export var display_name := "Display Name"
export (String, MULTILINE) var bio := "Fill this with the character's complete bio. Supports BBCode."
export var age := 0

## Default key to use if the user doesn't specify the image to display
export var default_image := "_"
## Holds the character's portraits, mapping expressions (keys) to an image texture.
export var images := {
	_ = null,
}


func _init() -> void:
	assert(default_image in images)


func get_default_image() -> Texture:
	return images[default_image]


func get_image(expression: String) -> Texture:
	return images.get(expression, get_default_image())


func is_narrator() -> bool:
	return id == Preloader.NARRATOR_ID
