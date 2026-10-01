extends CanvasLayer

@export var map_name_label: Label
@export var map_time_label: Label
@export var best_time_label : Label
@export var new_best_time_map_label: Label

func _ready() -> void:
	self.visible = false
	new_best_time_map_label.visible = false
	
func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	
	if map.current_map_save_data.has(map.key_best_time):	
		best_time_label.text = "Best Time: %4.1f" % map.current_map_save_data[map.key_best_time]
	else: 
		best_time_label.text = " "
	self.visible = true

func show_map_time(time: float) -> void:
	map_time_label.text = "%4.1f" % time
	

func show_new_map_best_time(new_time: float) -> void:
	new_best_time_map_label.text = "New best time: %f" % new_time
	new_best_time_map_label.visible = true
