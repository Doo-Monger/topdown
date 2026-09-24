extends Node
var DET_COUNT: int = 0 
var DET_COUNT_VALID: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree().current_scene.scene_file_path)
	for child_node in $Detectors.get_children():
		var DETECTOR: Detector = child_node as Detector
		if DETECTOR:
			print("counting!")
			DET_COUNT += 1
			DETECTOR.VALIDITY_CHANGED.connect(_on_detector_validity_changed)
	prints("Det Count", DET_COUNT)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_detector_validity_changed(VALID: bool) -> void:
	if VALID:
		DET_COUNT_VALID += 1
		if DET_COUNT_VALID == DET_COUNT:
			print("You are a king, GG!")
			_load_next_map()
	else:
		DET_COUNT_VALID -= 1
	print(DET_COUNT_VALID)
	
func _load_next_map() -> void: 
	var current_map_path: String = get_tree().current_scene.scene_file_path
	var split_path: Array = current_map_path.split(".")
	var next_map_number: int = split_path[1].to_int() + 1
	split_path[1] = str(next_map_number).pad_zeros(3)
	var next_map_path: String = ".".join(split_path)
	
	if ResourceLoader.exists(next_map_path):
		get_tree().change_scene_to_file(next_map_path)
	else:
		get_tree().change_scene_to_file("res://maps/map.001.tscn")
