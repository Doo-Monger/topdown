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
	
func _start_load_next_map() -> void:
	Main.load_next_map_deferred.call_deferred()

func _on_detector_validity_changed(VALID: bool) -> void:
	if VALID:
		DET_COUNT_VALID += 1
		if DET_COUNT_VALID == DET_COUNT:
			print("You are a king, GG!")
			Main.load_next_map()
	else:
		DET_COUNT_VALID -= 1
	print(DET_COUNT_VALID)
