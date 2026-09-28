extends CanvasLayer

@export var map_name_label: Label
@export var map_time_label: Label

func _ready() -> void:
	self.visible = false
	
func show_map_info(map: GameMap) -> void:
	map_name_label.text = map.map_name
	self.visible = true

func show_map_time(time: float) -> void:
	map_time_label.text = "%4.1f" % time
