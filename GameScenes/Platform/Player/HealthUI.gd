extends Control

var max_health := 100

onready var health_bar = $ProgressBar

func _ready():
	self.max_health = PlayerStats.max_health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")

func set_health(value) -> void:
	health_bar.value = clamp(value, 0, max_health)

func set_max_health(value) -> void:
	self.max_health = int(max(value, 1))
	


