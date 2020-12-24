extends Control




func _on_MenuButton_pressed():
	get_tree().change_scene($MenuButton.target_scene)
