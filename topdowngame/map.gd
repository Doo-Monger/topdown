extends Node
var DET_COUNT: int = 0 
var DET_COUNT_VALID: int = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child_node in $Detectors.get_children():
		var DETECTOR: Detector = child_node as Detector
		if DETECTOR:
			DET_COUNT += 1
			DETECTOR.VALIDITY_CHANGED.connect(_on_detector_validity_changed)
	
	Main.map_loaded(self.scene_file_path)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _start_load_next_map() -> void:
	Main.load_next_map_deferred.call_deferred()

func _on_detector_validity_changed(VALID: bool) -> void:
	if VALID:
		DET_COUNT_VALID += 1
		if DET_COUNT_VALID == DET_COUNT:
			Main.load_next_map()
	else:
		DET_COUNT_VALID -= 1
