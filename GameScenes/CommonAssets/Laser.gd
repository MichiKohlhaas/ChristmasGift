extends Area2D

export (int) var speed = 5
var velocity = Vector2()
var direction = 1

func _ready():
	pass
	
func _physics_process(delta) -> void:
	velocity.x = speed * direction * delta
	translate(velocity)
	$AnimatedSprite.play("default")

func set_laser_direction(dir) -> void:
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


# warning-ignore:unused_argument
func _on_Laserbolt_body_entered(body) -> void:
	queue_free()
