extends Area2D

export(String, FILE, "*.tscn") var target_scene

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
# warning-ignore:return_value_discarded
			get_tree().change_scene(target_scene)
