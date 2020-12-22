extends KinematicBody2D
onready var stats = $Stats
var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Stats_no_health():
	queue_free()

func _on_Sprite_animation_finished():
	pass # Replace with function body.


func _on_Sprite_frame_changed():
	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
