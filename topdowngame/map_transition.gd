extends Node
var root_window: Window
@export var animation_player: AnimationPlayer

func _ready() -> void:
	root_window = get_tree().root
	root_window.remove_child.call_deferred(self)

func play_enter_map() -> void:
	animation_player.play("enter_map")
	root_window.remove_child(self)
	
func play_exit_map()  -> void:
	root_window.add_child(self)
	animation_player.play("exit_map")
