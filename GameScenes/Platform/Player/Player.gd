extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 90
export var ROLL_SPEED = 120
export var FRICTION = 500

const UP = Vector2(0, -1)

var velocity = Vector2.ZERO

func _process(delta):
	velocity.y += 10
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		if input_vector.x < 0.0:
			$Sprite.flip_h = true
			$Sprite.play("walking")
		else:
			$Sprite.flip_h = false
			$Sprite.play("walking")
	else:
		$Sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -400
			$Sprite.play("jump")
	
	velocity = move_and_slide(velocity, UP)
