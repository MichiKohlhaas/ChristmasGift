extends KinematicBody2D

export (PackedScene) var Laserbolt
export (float) var time_between_shots
enum {
	PATROL,
	IDLE,
	CHASE,
	ATTACK,
}
const ENEMYDEATHEFFECT = preload("res://GameScenes/CommonAssets/Effects/Explosion.tscn")
const SPEED := 30
const GRAVITY := 10

var health := 10
var direction := -1 # face left
var facing := -1
var isShooting := false
var velocity := Vector2()
var state := PATROL

onready var stats = $Stats
onready var animation_player = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var right_floor_detector = $RightFloorDetector
onready var left_floor_detector = $LeftFloorDetector
onready var laser_origin = $LaserOrigin
onready var pdz = $PlayerDetectionZone

func _ready():
	set_physics_process(false)
	velocity.x = SPEED * direction
	
# warning-ignore:unused_argument
func _physics_process(delta):
	velocity.y += GRAVITY
	if pdz.can_see_player():
		state = ATTACK
	else:
		state = PATROL
	# buggy
#	if is_on_wall():
#		velocity.x *= -1
#		scale.x *= -1
	if not left_floor_detector.is_colliding():
		flip_positions(true)
	if not right_floor_detector.is_colliding():
		flip_positions(false)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 300 * delta)
		PATROL:
			if $PatrolTimer.time_left == 0:
				patrol_timer()
		CHASE:
			pass
		ATTACK:
			if not isShooting and pdz.player != null:
				if(position.x > pdz.player.position.x):
					# player is on the left of enemy
					if facing == 1:
						# need to turn and look at player
						flip_positions(false)
				else:
					# player is on the right of enemy
					if facing == -1:
						flip_positions(true)
				attack_state()
				move_to_player()
	move()


func patrol_timer() -> void:
	$PatrolTimer.start(rand_range(1, 6))
	

func move() -> void:
	velocity.y = move_and_slide(velocity, Vector2.UP).y

func flip_positions(flip_h: bool) -> void:
	velocity.x *= self.direction
	$Sprite.flip_h = flip_h
	laser_origin.position.x *= self.direction
	facing *= self.direction

func move_to_player() -> void:
#	velocity.y = move_and_slide(velocity, Vector2.UP).y
	pass

func attack_state() ->void:
	isShooting = true
	var laser_instance = Laserbolt.instance()
	laser_instance.speed = 150
	if sign(laser_origin.position.x) == 1:
		laser_instance.set_laser_direction(1)
	elif sign(laser_origin.position.x) == -1:
		laser_instance.set_laser_direction(-1)
	get_parent().add_child(laser_instance)
	laser_instance.position = laser_origin.global_position
	$Timer.start(time_between_shots)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = ENEMYDEATHEFFECT.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

# warning-ignore:unused_argument
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.2)

func _on_Hurtbox_invincibility_ended():
	self.animation_player.play("Stop")

func _on_Hurtbox_invincibility_started():
	self.animation_player.play("Start")

func _on_Timer_timeout():
	isShooting = false

func _on_PatrolTimer_timeout():
	flip_positions(!$Sprite.flip_h)
	pick_random_state([IDLE, PATROL])
