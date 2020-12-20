extends KinematicBody2D

const LASERBOLT = preload("res://GameScenes/CommonAssets/Laserbolt.tscn")
const UP = Vector2(0, -1)

export var ACCELERATION = 500
export var MAX_SPEED = 200
export var FRICTION = 500
export var GRAVITY = 20
export var JUMP_HEIGHT = -550

var velocity = Vector2.ZERO
var isJumping = false
var isCrouching = false
var isAttacking = false

onready var camera = $Camera2D
onready var limitLeft = $LeftLimit
onready var limitBottom = $BottomLeftLimit

func _ready():
	camera.limit_left = limitLeft.position.x
	camera.limit_top = limitLeft.position.y # Might change in the future, depends on the level height
	camera.limit_bottom = limitBottom.position.y

# TODO: refactor
func _physics_process(delta):
	var input_vector := Vector2.ZERO
	velocity.y += GRAVITY
	if not isCrouching:
		if Input.is_action_pressed("right"):
			input_vector.x = 1
			face_direction(input_vector)
			if not isJumping:
				$Sprite.play("run_shoot")
		elif Input.is_action_pressed("left"):
			input_vector.x = -1
			face_direction(input_vector)
			if not isJumping:
				$Sprite.play("run_shoot")
		elif input_vector == Vector2.ZERO and not isJumping:
			$Sprite.play("idle")
		
	if not is_on_floor():
		isJumping = true
		isCrouching = false
		$Sprite.play("jump")
	else:
		isJumping = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_HEIGHT
		elif Input.is_action_pressed("crouch"):
			$Sprite.play("crouch")
			isCrouching = true
		elif Input.is_action_just_released("crouch"):
			isCrouching = false
	
	move(input_vector, delta)

#func move_state(delta):
#	var isFriction = false
#	var input_vector = Vector2.ZERO
#	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#	input_vector = input_vector.normalized()
##
#	face_direction(input_vector)
#	if input_vector != Vector2.ZERO and !isJumping:
#		if Input.is_action_pressed("walk") and !isAttacking:
#			$Sprite.play("walking")
##			slow down the velocity to a walking speed
#			velocity.x = lerp(velocity.x, 0, 0.25)
#		else:
#			$Sprite.play("run_shoot")
#	else:
#		if !isJumping and !isCrouching and !isAttacking:
#			velocity.x = 0
#			$Sprite.play("idle")
#		elif isAttacking and !isCrouching:
#			$Sprite.play("shoot")
#	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
##	# TODO: refactor this, too many if-else statements
#	if is_on_floor():
#		isJumping = false
#		if Input.is_action_just_pressed("jump"):
#			velocity.y = JUMP_HEIGHT
#		if isFriction:
#			velocity.x = lerp(velocity.x, 0, 0.2)
#	else:
#		if velocity.y < 0:
#			$Sprite.play("jump")
#			isCrouching = false
#			isJumping = true
#		else:
##			if !$Sprite.is_playing():
#			$Sprite.set_animation("jump")
#			$Sprite.set_frame(3)
#			isJumping = true
#		if isFriction:
#			velocity.x = lerp(velocity.x, 0, 0.05)
#	move()

func move(input_vector: Vector2, delta: float):
	input_vector = input_vector.normalized()
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity, UP)

#func _unhandled_input(event):
#	if event.is_action_pressed("crouch") and is_on_floor():
#		isCrouching = true
#		$Sprite.play("crouch")
#	if event.is_action_released("crouch"):
#		isCrouching = false
#	if event.is_action_pressed("shoot"):
#		state = ATTACK
#	get_tree().set_input_as_handled()
#
#func attack_state():
#	#TODO: seems the position changes (reverts?) on the second shot. Fix
#	var dir = 1
#	isAttacking = true
#	dir = 1 if !$Sprite.flip_h else -1
#	var laserbolt = LASERBOLT.instance()
#	laserbolt.set_laser_direction(dir)
#	get_parent().add_child(laserbolt)
#	$LaserOriginStanding.position.x *= dir
#	laserbolt.position = $LaserOriginStanding.global_position
#	print($LaserOriginStanding.position)
#	print(laserbolt.position)
#	state = MOVE
	

func face_direction(input_vector: Vector2):
	if input_vector.x < 0:
		$Sprite.flip_h = true
	elif input_vector.x > 0:
		$Sprite.flip_h = false

func _on_Sprite_animation_finished():
	pass


func _on_Sprite_frame_changed():
	pass
