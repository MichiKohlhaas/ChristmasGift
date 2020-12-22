extends KinematicBody2D

export (PackedScene) var Laserbolt
enum {
	WANDER,
	IDLE,
	CHASE,
}
const SPEED := 30
const GRAVITY := 10

var health := 10
var direction := -1 # face left
var isShooting := false
var velocity := Vector2()
var state := WANDER

onready var stats = $Stats
onready var animation_player = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var right_floor_detector = $RightFloorDetector
onready var left_floor_detector = $LeftFloorDetector
onready var laser_origin = $LaserOrigin
onready var pdz = $PlayerDetectionZone

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	velocity.x = SPEED * direction
	
func _physics_process(delta):
	velocity.y += GRAVITY
	
	if is_on_wall():
		velocity.x *= -1
	if not left_floor_detector.is_colliding():
		velocity.x *= -1
	if not right_floor_detector.is_colliding():
		velocity.x *= -1
		
	velocity.y = move_and_slide(velocity, Vector2.UP).y
#	if direction == 1:
#		$Sprite.flip_h = true
#	else:
#		$Sprite.flip_h = false
#	if is_on_wall() or not floor_checker.is_colliding() and is_on_floor():
#		direction *= -1
#		floor_checker.position.x *= -1
		
#	if raycast.is_colliding() and not isShooting:
#		isShooting = true
#		var laser_instance = Laserbolt.instance()
#		laser_instance.speed = 200
#		if sign(laser_origin.position.x) == 1:
#			laser_instance.set_laser_direction(1)
#		elif sign(laser_origin.position.x) == -1:
#			laser_instance.set_laser_direction(-1)
#		get_parent().add_child(laser_instance)
#		laser_instance.position = laser_origin.global_position
#
#		$Timer.start(0.8)
	
	
	

func _on_Stats_no_health():
	queue_free()

func _on_Sprite_animation_finished():
	direction *= -1
#	floor_checker.position.x *= -1
	state = WANDER


func _on_Sprite_frame_changed():
	pass # Replace with function body.


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
