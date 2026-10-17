class_name MapObject
extends Area2D

@export var player_detect_min: int
@export var player_detect_max: int
@export var area_player_detect: Area2D = Area2D.new()

func _ready() -> void:
	area_player_detect.radius = player_detect_max
	area_player_detect.body_entered.connect(_on_character_entered)

func _on_character_entered(body: CharacterBody2D) -> void:
	return

## this might all be fucked!
