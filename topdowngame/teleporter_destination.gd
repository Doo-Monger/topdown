class_name TeleporterDestination
extends MapObject

signal validity_changed(valid: bool)
@export var sprite: Sprite2D
@export var particles: GPUParticles2D

var object_count: int = 0 

func _ready() -> void:
	super()
#func _process(delta: float) -> void:
	#if player_in_range:
		###print(line.default_color.a)
		###print(distance_to_player)
		#var distance_to_character:float = character.position.distance_to(self.global_position)
		#line.default_color.a = 1 - distance_to_character/player_detect_max 
	#
func _on_body_entered(_body: Node2D) -> void:
	if object_count == 0 and _body is not PlayerCharacter:
		validity_changed.emit(false)
	object_count += 1
func _on_body_exited(_body: Node2D) -> void:
	object_count -= 1
	if object_count == 0:
		validity_changed.emit(true)
