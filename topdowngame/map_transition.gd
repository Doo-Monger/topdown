extends Node
var root_window: Window

func _ready() -> void:
	root_window = get_tree().root
	root_window.remove_child.call_deferred(self)
func play_enter_map() -> void:
	root_window.remove_child(self)

func play_exit_map()  -> void:
	root_window.add_child(self)
