extends Area2D

#const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

#func create_hit_effect():
#	var effect = HitEffect.instance()
#	var main = get_tree().current_scene
#	main.add_child(effect)
#	effect.global_position = global_position

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	emit_signal("invincibility_started")

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func _on_Timer_timeout():
	# use self to call the variable's setter
	self.invincible = false
	emit_signal("invincibility_ended")


func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
