extends Area2D

export (int) var heal_amount

func _on_Node2D_area_entered(area):
	if area.is_in_group("Player"):
		area.stats.health += heal_amount
		queue_free()


func _on_Node2D_body_entered(body):
	if body.is_in_group("Player"):
		body.stats.health += heal_amount
		queue_free()
