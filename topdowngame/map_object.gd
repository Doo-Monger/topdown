class_name MapObject
extends Area2D

@export var player_detect_min: int
@export var player_detect_max: int
@export var area_player_detect: Area2D

func _ready() -> void:
	if area_player_detect:
		area_player_detect.radius = player_detect_max
		area_player_detect._on_rad
