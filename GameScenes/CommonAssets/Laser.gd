extends Area2D

export var speed = 100
var velocity = Vector2()
var direction = 1

func _ready():
	pass
	
func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	$AnimatedSprite.play("default")

func set_laser_direction(dir):
	direction  = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# warning-ignore:unused_argument
func _on_Laserbolt_body_entered(body):
	queue_free()
