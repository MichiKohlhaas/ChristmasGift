extends Node
class_name Stats

export var max_health = 1 setget set_max_health
var health = max_health setget set_health

# not optimized because it'll check every frame what the health is, why do that?
#func _process(delta):
#	if health <= 0:
#		emit_signal("no_health")

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
