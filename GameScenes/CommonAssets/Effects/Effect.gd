extends AnimatedSprite

func _ready():
	#object that has the signal.connect(signal to connect to, the object or node that has the function, the function we're connecting')
	var _error = connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
