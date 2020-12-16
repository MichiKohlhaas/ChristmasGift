extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 200
export var FRICTION = 500
export var GRAVITY = 20
export var JUMP_HEIGHT = -500

const UP = Vector2(0, -1)

var velocity = Vector2.ZERO
var isJumping = false

func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY
	var isFriction = false
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and !isJumping:
		if input_vector.x < 0:
			$Sprite.flip_h = true
			$Sprite.play("run")
		else:
			$Sprite.flip_h = false
			$Sprite.play("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		if !isJumping:
			$Sprite.play("idle")
			isFriction = true
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if is_on_floor():
		isJumping = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_HEIGHT
		if isFriction:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if velocity.y < 0:
			$Sprite.play("jump")
			isJumping = true
		else:
			$Sprite.set_frame(3)
		if isFriction:
			velocity.x = lerp(velocity.x, 0, 0.05)
	
	velocity = move_and_slide(velocity, UP)



