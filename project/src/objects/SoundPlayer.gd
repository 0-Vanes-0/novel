extends AudioStreamPlayer

func _ready() -> void:
	if(self.stream):
		self.play()
		yield(self, "finished")
	queue_free()
