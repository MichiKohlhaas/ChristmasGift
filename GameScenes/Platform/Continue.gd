extends Control

var save_path := "user://save.dat"

func _on_LoadFile_pressed():
	GameSave.load(1)
