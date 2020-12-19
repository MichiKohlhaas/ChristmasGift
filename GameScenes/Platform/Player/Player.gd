extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 200
export var FRICTION = 500
export var GRAVITY = 20
export var JUMP_HEIGHT = -550

const UP = Vector2(0, -1)
enum {
	MOVE,
	CROUCH,
	JUMP,
	WALK,
}

onready var camera = $Camera2D
onready var limitLeft = $LeftLimit
onready var limitBottom = $BottomLeftLimit

var state = MOVE
var velocity = Vector2.ZERO
var isJumping = false
var isCrouching = false
var isAttacking = false


func _ready():
	camera.limit_left = limitLeft.position.x
	camera.limit_top = limitLeft.position.y # Might change in the future, depends on the level height
	camera.limit_bottom = limitBottom.position.y

func _physics_process(delta):
	velocity.y += GRAVITY
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	var isFriction = false
	var input_vector = Vector2.ZERO
#	# TODO: Fix so that the character can "move" while jumping.
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector = input_vector.normalized()
#
	face_direction(input_vector)
	if input_vector != Vector2.ZERO and !isJumping and !isAttacking:
		if Input.is_action_pressed("walk"):
			$Sprite.play("walking")
#			slow down the velocity to a walking speed
			velocity.x = lerp(velocity.x, 0, 0.25)
		else:
			$Sprite.play("run")
	else:
		if !isJumping and !isCrouching and !isAttacking:
			velocity.x = 0
			$Sprite.play("idle")
		elif isAttacking:
			$Sprite.play("shoot")
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#	# TODO: refactor this, too many if-else statements
	if is_on_floor():
		isJumping = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_HEIGHT
		if isFriction:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if velocity.y < 0:
			$Sprite.play("jump")
			isCrouching = false
			isJumping = true
		else:
#			if !$Sprite.is_playing():
			$Sprite.set_animation("jump")
			$Sprite.set_frame(3)
			isJumping = true
		if isFriction:
			velocity.x = lerp(velocity.x, 0, 0.05)
	velocity = move_and_slide(velocity, UP)

func move():
	velocity = move_and_slide(velocity, UP)

func _unhandled_input(event):
	if event.is_action_pressed("crouch") and is_on_floor():
		isCrouching = true
		$Sprite.play("crouch")
	if event.is_action_released("crouch"):
		isCrouching = false
	
	if event.is_action_pressed("shoot") and !isAttacking:
		isAttacking = true
		if isJumping and !is_on_floor():
			#shoot blaster while in air
			pass
	if event.is_action_released("shoot") and isAttacking:
		isAttacking = false
	
	get_tree().set_input_as_handled()
	
	
func face_direction(input_vector: Vector2):
	if input_vector.x < 0:
		$Sprite.flip_h = true
	elif input_vector.x > 0:
		$Sprite.flip_h = false


func _on_Sprite_animation_finished():
	pass


func _on_Sprite_frame_changed():
	pass
