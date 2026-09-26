extends Node
const game_save_path: String = "user://game.save"

var current_map_path: String

func load_next_map() -> void: 
	print("loading next map!!!")
	var split_path: Array = current_map_path.split(".")
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
	print("loading map!!!")
	ResourceLoader.load_threaded_request(map_path)
	
	#await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(map_path)
	)
	
	#await MapTransition.play_enter_map()
func map_loaded(map_path:String) -> void:
	current_map_path = map_path
	
	var game_save_file: FileAccess = FileAccess.open(game_save_path, FileAccess.WRITE)
	game_save_file.store_var(map_path)

func can_continue() -> bool:
	return FileAccess.file_exists(game_save_path)
func load_continue_map() -> void:
	if not can_continue():
		print("No save file!")
		return
	var game_save_file: FileAccess = FileAccess.open(game_save_path, FileAccess.READ)
	load_map(game_save_file.get_as_text())
	
