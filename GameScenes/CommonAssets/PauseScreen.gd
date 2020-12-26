extends CanvasLayer

var paused := false

func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel") and not paused:
		paused = true
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused # toggle pause status


func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)
	paused = false
	
func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible


func _on_Button2_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
