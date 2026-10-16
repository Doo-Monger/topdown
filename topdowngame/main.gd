extends Node

var animation_is_playing: bool = false 

const map_path_prefix: String = "res://maps/"
const game_save_path: String = "user://save.save"
const game_save_version: int = 1


#Three Dictionaries, Largest is game_save_data, defined here.
#game_save_data contains version, location of map to be loaded, and a sub dictionary named
#per_map_data 

var game_save_data: Dictionary = {}
const key_game_save_version: String = "version"
const key_per_map_data: String = "per_map_data"
const key_map_path: String = "map_path"
const key_game_stats: String = "statistics"

var game_stats: Dictionary = {}
var game_stats_keys: Array = [
	"total_distance",
	"buttons_pushed",
	"time_played",
	"teleporters_used"
	]

func _ready() -> void:
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
	
	if not game_save_data.has(key_game_stats):
		for stat_name: String in game_stats_keys:
			game_stats[stat_name] = 0
		#game_stats = {
			#key_distance_travelled : 0,
			#key_buttons_pushed : 0,
			#key_time_played : 0
		#}
		
		game_save_data[key_game_stats] = game_stats
		print("No stats found!")
	else:
		game_stats = game_save_data[key_game_stats] as Dictionary
		prints("Stats found!", game_stats)
func load_next_map() -> void: 
	print("loading next map!!!")
	var split_path: Array = (game_save_data[key_map_path] as String).split(".")
	var next_map_number: int = split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path: String = ".".join(split_path)
	
	ResourceLoader.load_threaded_request(next_map_path)
	
	animation_is_playing = true
	await MapTransition.play_exit_map()
	
	if ResourceLoader.exists(next_map_path):
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(next_map_path)
		)
	else:
		get_tree().change_scene_to_file("res://maps/map.001.tscn")
	
	await MapTransition.play_enter_map()	
	animation_is_playing = false
func load_map(map_path : String) -> void:
	prints("loading map " + map_path)
	ResourceLoader.load_threaded_request(map_path)
	
	#await MapTransition.play_exit_map()
	
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(map_path)
	)
	
	#await MapTransition.play_enter_map()
func map_loaded(map: GameMap) -> void:
	#Defining map to be loaded (entry for key_map_path)
	var map_path: String = map.scene_file_path
	game_save_data[key_map_path] = map.scene_file_path
	
	#Defining per_map_data as entry dictionary within game_save data
	#under key key_per_map_data
	var per_map_data: Dictionary = game_save_data[key_per_map_data] as Dictionary
	
	#Checking if per_map_data contains current map path. If not, generate new dictionary
	#within per_map_data with a key of map_path
	if not per_map_data.has(map_path):
		per_map_data[map_path] = {}
	else:
	#Updating current_map_save_data to be the same as whats in the save file. I think
	#this also works the other way (updating save file based on data in map.gd) because
	#they are now the same object?
		map.current_map_save_data = per_map_data[map_path]
	
	var game_save_file: FileAccess = FileAccess.open(game_save_path, FileAccess.WRITE)
	game_save_file.store_var(game_save_data)
	print(game_stats)

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

func stats_update_total_distance(amount: int) -> void:
	game_stats["total_distance"] += amount
func stats_update_buttons_pushed(amount: int) -> void:
	game_stats["buttons_pushed"] += amount
func stats_update_time_played(amount: float) -> void:
	game_stats["time_played"] += snapped(amount, 0.1)
func stats_update_teleporters_used(amount: int) -> void:
	game_stats["teleporters_used"] += amount
#func stats_update_all() -> void:		if want to scale, make it take an array.
#	stats_update_buttons_pushed()
	
	
	
