extends Node

const game_save_path: String = "user://save.save"
const key_map_path: String = "map_path"
const game_save_version: int = 1
const key_game_save_version: String = "version"

var game_save_data: Dictionary = {}
const map_path_prefix: String = "res://maps/"
const key_per_map_data: String = "per_map_data"

func _ready() -> void:
#region Saving/loading

	if FileAccess.file_exists(game_save_path):
		var game_save_file: FileAccess = FileAccess.open(
			game_save_path, FileAccess.READ
		)
		game_save_data = game_save_file.get_var() as Dictionary
		if game_save_data[key_game_save_version] > game_save_version:
			print("Outdated Save Format!")
			game_save_data = {}
	
	game_save_data[key_game_save_version] = game_save_version
	
	if not game_save_data.has(key_per_map_data):
		game_save_data[key_per_map_data] = {}	
	#endregion
func load_next_map() -> void: 
	print("loading next map!!!")
	var split_path: Array = (game_save_data[key_map_path] as String).split(".")
	var next_map_number: int = split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path: String = ".".join(split_path)
	
	ResourceLoader.load_threaded_request(next_map_path)
	
	await MapTransition.play_exit_map()
	
	if ResourceLoader.exists(next_map_path):
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(next_map_path)
		)
	else:
		get_tree().change_scene_to_file("res://maps/map.001.tscn")
	
	await MapTransition.play_enter_map()	
func load_map(map_path : String) -> void:
	prints("loading map " + map_path)
	ResourceLoader.load_threaded_request(map_path)
	
	#await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(map_path)
	)
	
	#await MapTransition.play_enter_map()
func map_loaded(map: GameMap) -> void:
	var map_path: String = map.scene_file_path
	game_save_data[key_map_path] = map.scene_file_path
	
	var per_map_data: Dictionary = game_save_data[key_per_map_data] as Dictionary
	
	if not per_map_data.has(map_path):
		per_map_data[map_path] = {}
	else:
		map.current_map_save_data = per_map_data[map_path]
	
	var game_save_file: FileAccess = FileAccess.open(game_save_path, FileAccess.WRITE)
	game_save_file.store_var(game_save_data)

func can_continue() -> bool:
	return game_save_data.has(key_map_path)
func load_continue_map() -> void:
	if not can_continue():
		print("No save file!")
		return
		
	#var game_save_file: FileAccess = FileAccess.open(game_save_path, FileAccess.READ)
	#var game_save_data : Dictionary = game_save_file.get_var() as Dictionary
	var map_path: String = game_save_data[key_map_path]
	
	#if game_save_data[key_game_save_version] > game_save_version:
		#print("Unknown Save Format!")
		#return
	if (not map_path.begins_with(map_path_prefix) or map_path.contains("..")):
		print("Invalid map path!")
		return
	else:
		load_map(map_path)
	
