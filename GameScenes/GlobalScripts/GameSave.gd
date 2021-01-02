extends Node

const SaveGame = preload("res://GameScenes/GlobalScripts/SaveGame.gd")
var save_folder := "user://debug/save"
var save_name := "save_%s.tres"

func save(id: int):
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_game)
		
	var directory : Directory = Directory.new()
	if not directory.dir_exists(save_folder):
		directory.make_dir_recursive(save_folder)
	
	var save_path = save_folder.plus_file(save_name % id)
	var error: int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print("Issue with saving %s to %s" % [id, save_path])
	else:
		print(save_game.data)


func load(id: int):
	var save_file_path = save_folder.plus_file(save_name % id)
	var file = File.new()
	assert(file.file_exists(save_file_path))
	
	var save_game = load(save_file_path)
	print(save_game)
	for node in get_tree().get_nodes_in_group("save"):
		#node.load(save_game)
		print(node.name)
		
