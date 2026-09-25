extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_next_map() -> void: 
	var current_map_path: String = get_tree().current_scene.scene_file_path
	var split_path: Array = current_map_path.split(".")
	var next_map_number: int = split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path: String = ".".join(split_path)
	
	if ResourceLoader.exists(next_map_path):
		get_tree().change_scene_to_file.call_deferred(next_map_path)
	else:
		get_tree().change_scene_to_file("res://maps/map.001.tscn")

		
func load_next_map_deferred() -> void:
	var current_map_path: String = get_tree().current_scene.scene_file_path
	
