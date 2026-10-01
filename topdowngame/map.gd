class_name GameMap
extends Node

@export var map_name: String = "Map Name Here"

var DET_COUNT: int = 0 
var DET_COUNT_VALID: int = 0 

var current_map_time: float = 0.0 
var map_is_completed: bool = false

var current_map_save_data: Dictionary
const key_best_time: String = "best_time"

func _ready() -> void:
	for child_node in $Detectors.get_children():
		var DETECTOR: Detector = child_node as Detector
		if DETECTOR:
			DET_COUNT += 1
			DETECTOR.VALIDITY_CHANGED.connect(_on_detector_validity_changed)
	
	Main.map_loaded(self)
	Hud.show_map_info(self)
func _process(delta: float) -> void:
	if not map_is_completed and not Main.animation_is_playing:
		current_map_time += delta
	Hud.show_map_time(current_map_time)
	
func _start_load_next_map() -> void:
	Main.load_next_map_deferred.call_deferred()

func _on_detector_validity_changed(VALID: bool) -> void:
	if VALID:
		DET_COUNT_VALID += 1
		if DET_COUNT_VALID == DET_COUNT:
			map_is_completed = true
			_update_best_time()
			Main.load_next_map()
	else:
		DET_COUNT_VALID -= 1
	
func _update_best_time() -> void:
	if (
	not current_map_save_data.has(key_best_time)
	or current_map_time < current_map_save_data[key_best_time]
	):
		current_map_save_data[key_best_time] = snapped(current_map_time, 0.01)
		print("New Best Time:" + str(current_map_save_data[key_best_time]))
		Hud.show_new_map_best_time(current_map_save_data[key_best_time])
