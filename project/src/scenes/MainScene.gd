extends Control

onready var background := $Background
onready var currText := $TextBox/RichTextLabel
onready var currName := $TextBox/NameBox/Label



func _ready() -> void:
	background.texture = Preloader.testBackground
	currName.text = "Кто-то"
	currText.append_bbcode("\n" + "А компот? А Enter нажать?")
	emit_signal("ready")
