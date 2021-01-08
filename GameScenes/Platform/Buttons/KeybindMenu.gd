extends Panel

onready var button_container = $VBoxContainer

var keybinds

func _ready():
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		
