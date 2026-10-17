class_name MapObject
extends Area2D

@export var player_detect_min: int
@export var player_detect_max: int
var player_in_range: bool = false
var character: PlayerCharacter

var is_active: bool = true

func _ready() -> void:
	if player_detect_max != 0:
		var area_player_detect: Area2D = Area2D.new()
		var collision_player_detect: CollisionShape2D = CollisionShape2D.new()
		var shape_player_detect: CircleShape2D = CircleShape2D.new()
		
		area_player_detect.add_child(collision_player_detect)
		collision_player_detect.set_shape(shape_player_detect)
		collision_player_detect.position = Vector2.ZERO
		shape_player_detect.radius = player_detect_max
		
		area_player_detect.body_entered.connect(_on_character_entered)
		area_player_detect.body_exited.connect(_on_character_exited)
		area_player_detect.monitorable = false
		
		self.add_child(area_player_detect)
		
func _on_character_entered(body: PlayerCharacter) -> void:
	player_in_range = true
	character = body
	prints("super char enter " , player_in_range)
func _on_character_exited(_body: PlayerCharacter) -> void:
	player_in_range = false
	character = null
	prints("super char exit " , player_in_range)

func button_toggle(status: bool) -> void:
	is_active = status
	
	
	
