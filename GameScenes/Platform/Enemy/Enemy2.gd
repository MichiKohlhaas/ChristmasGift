extends Node2D
# this is not good code practice to copy-paste the same code
# TODO: Refactor code to use a parent "enemy" class

export (PackedScene) var Laserbolt
export (float) var time_between_shots
enum {
	PATROL,
	IDLE,
	CHASE,
	ATTACK,
}
const ENEMYDEATHEFFECT = preload("res://GameScenes/CommonAssets/Effects/Explosion.tscn")

var direction := -1 # face left
var facing := -1
var isShooting := false
var velocity := Vector2()
var state := PATROL

onready var stats = $Stats
onready var animation_player = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var laser_origin = $LaserOrigin
onready var pdz = $PlayerDetectionZone

func _ready() -> void:
	set_physics_process(false)

# warning-ignore:unused_argument
func _physics_process(delta) -> void:
	match state:
		IDLE:
			detect_player()
			if $ThotPatrolTimer.time_left == 0:
				patrol_timer()
			$Sprite.play("idle")
		PATROL:
			detect_player()
			if $ThotPatrolTimer.time_left == 0:
				patrol_timer()
			
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
			else:
				state = IDLE

func detect_player() -> void:
	if pdz.can_see_player():
		state = ATTACK

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

func flip_positions(flip_h: bool) -> void:
	velocity.x *= self.direction
	$Sprite.flip_h = flip_h
	laser_origin.position.x *= self.direction
	facing *= self.direction

func patrol_timer() -> void:
	$ThotPatrolTimer.start(rand_range(1, 6))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Timer_timeout():
	isShooting = false

func _on_Hurtbox_invincibility_ended():
	self.animation_player.play("Stop")


func _on_Hurtbox_invincibility_started():
	self.animation_player.play("Start")


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.2)


func _on_ThotPatrolTimer_timeout():
	# BEGONE
	# THOT!
	pick_random_state([IDLE, PATROL])



func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = ENEMYDEATHEFFECT.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
