class_name ChoiceSelector
extends VBoxContainer

signal choice_made(target_id)



func display(choices: Array) -> void:
	for choice in choices:
		var button := Button.new()
		button.text = choice.label
		button.rect_min_size.y = 100
		button.connect("pressed", self, "_on_Button_pressed", [choice.target])
		add_child(button)
	# Temporary fix for the buttons not showing when there are consecutive choice nodes
	yield(get_tree(), "idle_frame")
	(get_child(0) as Button).grab_focus()


func _on_Button_pressed(target_id: int) -> void:
	emit_signal("choice_made", target_id)
	_clear()


func _clear() -> void:
	for child in get_children():
		child.queue_free()
