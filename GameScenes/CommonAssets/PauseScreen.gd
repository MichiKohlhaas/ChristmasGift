extends CanvasLayer

var paused := false
var counter := 0

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
	
func set_visible(is_visible: bool):
	for node in get_children():
		node.visible = is_visible


func _on_Save_pressed():
	GameSave.save(counter)
	counter += 1


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	# TODO: change context to be entire scene, not just file name
	var context = get_tree().current_scene.filename
	SceneChanger.change_scene("res://GameScenes/Platform/Buttons/OptionsMenu.tscn", {"previous_scene": context})
	
