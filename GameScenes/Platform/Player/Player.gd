extends KinematicBody2D

const UP = Vector2(0, -1)
const PLAYER_HURT_SOUND = preload("res://GameScenes/Platform/Player/PlayerHurtSound.tscn")
export (PackedScene) var Laserbolt
export (int) var ACCELERATION = 500
export (int) var MAX_SPEED = 200
export (int) var FRICTION = 500
export (int) var GRAVITY = 20
export (int) var JUMP_HEIGHT = -550

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var isJumping := false
var isCrouching := false
var isAttacking := false
var hurtbox_og_height := 0.0 
var hurtbox_og_posy := 0.0 
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var hurtbox_collisionshape = $Hurtbox/CollisionShape2D

func _ready():
	stats.set_health(stats.max_health)
	var _v = stats.connect("no_health", self, "death")
	hurtbox_og_height = hurtbox_collisionshape.shape.height
	hurtbox_og_posy = hurtbox_collisionshape.position.y


# TODO: refactor to state machine
func _physics_process(delta) -> void:
	var input_vector := Vector2.ZERO
	velocity.y += GRAVITY
	if not isCrouching:
		if Input.is_action_pressed("right"):
			input_vector.x = 1
			face_direction(input_vector)
			if sign($LaserOriginRun.position.x) == -1:
				$LaserOriginRun.position.x *= -1
				$LaserOriginCrouch.position.x *= -1
				$LaserOriginStanding.position.x *= -1
			if not isJumping:
				$Sprite.play("run_shoot")
		elif Input.is_action_pressed("left"):
			input_vector.x = -1
			face_direction(input_vector)
			if sign($LaserOriginRun.position.x) == 1:
				$LaserOriginRun.position.x *= -1
				$LaserOriginCrouch.position.x *= -1
				$LaserOriginStanding.position.x *= -1
			if not isJumping:
				$Sprite.play("run_shoot")
		elif input_vector == Vector2.ZERO and not isJumping:
			if isAttacking:
				$Sprite.play("shoot")
			else:
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
			hurtbox_collisionshape.shape.height = 14.871
			hurtbox_collisionshape.position.y = 17.625
			$Sprite.play("crouch")
			isCrouching = true
		elif Input.is_action_just_released("crouch"):
			hurtbox_collisionshape.shape.height = hurtbox_og_height
			hurtbox_collisionshape.position.y = hurtbox_og_posy
			isCrouching = false
	
	if Input.is_action_just_pressed("shoot"):
		if input_vector == Vector2.ZERO and not isCrouching:
			laser_point_origin($LaserOriginStanding)
		elif isCrouching:
			laser_point_origin($LaserOriginCrouch)
		else:
			laser_point_origin($LaserOriginRun)
		isAttacking = true
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	move(input_vector, delta)

func laser_point_origin(origin: Position2D):
	var laser_instance = Laserbolt.instance()
	if sign(origin.position.x) == 1:
		laser_instance.set_laser_direction(1)
	elif sign(origin.position.x) == -1:
		laser_instance.set_laser_direction(-1)
	get_parent().add_child(laser_instance)
	laser_instance.position = origin.global_position

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

func move(input_vector: Vector2, delta: float) -> void:
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

func death():
	queue_free()
	get_tree().change_scene("res://GameScenes/Platform/World.tscn")


func face_direction(input_vector: Vector2) -> void:
	if input_vector.x < 0:
		$Sprite.flip_h = true
	elif input_vector.x > 0:
		$Sprite.flip_h = false

func _on_Sprite_animation_finished():
	if $Sprite.animation == "shoot":
		isAttacking = false


func _on_Sprite_frame_changed():
	pass


func _on_Hurtbox_invincibility_ended():
	self.animation_player.play("Stop")


func _on_Hurtbox_invincibility_started():
	self.animation_player.play("Start")


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.2)
	knockback = Vector2(area.direction, 0) * 120
	$Sprite.play("hurt")
	var playerHurtSound = PLAYER_HURT_SOUND.instance()
	get_tree().current_scene.add_child(playerHurtSound)
