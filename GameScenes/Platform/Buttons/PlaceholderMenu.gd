extends Control

func _ready():
	for button in $Panel/HBoxContainer.get_children():
		button.target_scene = SceneChanger.get_context("previous_scene")
		button.connect("pressed", self, "_on_Button_pressed", [button.target_scene])


func _on_Button_pressed(target_scene):
# warning-ignore:return_value_discarded
# TODO: on return to World the game is still paused, return to pause menu
	get_tree().change_scene(target_scene)
