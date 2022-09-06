# Displays and animates [Character] portraits, for example, entering from the left or the right.
class_name CharacterDisplayer
extends Node

# Emitted when the characters finished displaying or finished their animation.
signal display_finished

# Maps animation text ids to a function that animates a character sprite.
const ANIMATIONS := {
	"enter" : "_enter", # Сюдя ТАКЖЕ можно будет добавить другие анимации, например, вздрагивания или тряску
	"leave" : "_leave",
	"move" : "_move",
}
const SIDE := {
	LEFT = "left", 
	MIDLEFT = "midleft",
	MIDDLE = "middle",
	MIDRIGHT = "midright",
	RIGHT = "right",
}
const COLOR_WHITE_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.0)

# Keeps track of the character displayed on either side.
var _displayed := {
	SIDE.LEFT : {
		character = null,
		sprite = null,
	},
	SIDE.MIDLEFT : {
		character = null,
		sprite = null,
	},
	SIDE.MIDDLE : {
		character = null,
		sprite = null,
	},
	SIDE.MIDRIGHT : {
		character = null,
		sprite = null,
	},
	SIDE.RIGHT : {
		character = null,
		sprite = null,
	},
}
onready var _POSITION2DS := {
	SIDE.LEFT: $Left,
	SIDE.MIDLEFT: $MiddleLeft,
	SIDE.MIDDLE: $Middle,
	SIDE.MIDRIGHT: $MiddleRight,
	SIDE.RIGHT: $Right,
}
onready var _tween: Tween = $Tween



#func _ready() -> void:
#	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")


func _unhandled_input(event: InputEvent) -> void:
	# If the player presses enter before the character animations ended, we seek to the end.
	if event.is_action_pressed(Config.BUTTONS.ACCEPT) and _tween.is_active():
		_tween.seek(INF)


func display(character: Character, expression := "", animation := "", side := "") -> void:
	if character == null or character.is_narrator():
		return
	if side != "_" and not (side in SIDE.values()):
		side = SIDE.MIDDLE
	
	var character_side := _find_displayed_character(character)
	if character_side == "":
		assert(side != "_", "You cannot write '_' if you add a character first time!!!")
		_displayed[side].sprite = _create_sprite(character.get_default_image())
		add_child(_displayed[side].sprite)
		_displayed[side].sprite.hide()
		_displayed[side].character = character
	else:
		side = character_side # TODO: move animation? [if side == "_"]?
	
	if expression != "" and expression != "_":
		_displayed[side].sprite.texture = character.get_image(expression)
	_displayed[side].sprite.position = _POSITION2DS[side].position
	
	if animation != "":
		call_deferred(ANIMATIONS[animation], side)


func _find_displayed_character(character: Character) -> String:
	for side in _displayed.keys():
		if _displayed[side].character == character:
			return side
	return ""


func _create_sprite(texture: Texture) -> Sprite:
	var sprite: Sprite = Sprite.new()
	sprite.texture = texture
	sprite.offset = Vector2(
			sprite.offset.x, 
			sprite.offset.y - texture.get_size().y / 2
	)
	return sprite


## Fades in and moves the character to the anchor position.
func _enter(from_side: String) -> void:
	var offset := 200 
	if from_side == SIDE.RIGHT or from_side == SIDE.MIDRIGHT:
		offset *= 1
	else:
		offset *= -1
	
	var sprite: Sprite = _displayed[from_side].sprite
	var start := sprite.position + Vector2(offset, 0.0)
	var end := sprite.position
	
	_tween.interpolate_property(
		sprite, 
		"position", 
		start, 
		end, 
		0.5, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		sprite, 
		"modulate", 
		COLOR_WHITE_TRANSPARENT, 
		Color.white, 
		0.25
	)
	_tween.start()
	
	# Set up the sprite
	# We don't use Tween.seek(0.0) here since that could conflict with running tweens and make them jitter back and forth
	sprite.show()
	sprite.position = start
	sprite.modulate = COLOR_WHITE_TRANSPARENT
	
	yield(_tween, "tween_all_completed")
	emit_signal("display_finished")


func _leave(from_side: String) -> void:
	var offset := 200 
	if from_side == SIDE.RIGHT or from_side == SIDE.MIDRIGHT:
		offset *= 1
	else:
		offset *= -1
	
	var sprite: Sprite = _displayed[from_side].sprite
	var start := sprite.position
	var end := sprite.position + Vector2(offset, 0.0)
	
	_tween.interpolate_property(
		sprite, 
		"position", 
		start, 
		end, 
		0.5, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		sprite,
		"modulate",
		Color.white,
		COLOR_WHITE_TRANSPARENT,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.25
	)
	_tween.start()
	_tween.seek(0.0)
	sprite.show()
	
	yield(_tween, "tween_all_completed")
	_displayed[from_side].sprite = null
	_displayed[from_side].character = null
	emit_signal("display_finished")
