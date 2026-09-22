extends Node2D
@export_range(0.9, 1.1) var JITTER_RAD_MIN: float = 1.00
@export_range(0.9, 1.1) var JITTER_RAD_MAX: float = 1.02
@export var JITTER_OFFSET: float = 0.25
@export var JITTER_SPEED: float = 6.0
@export var LIGHT_A: PointLight2D
@export var LIGHT_B: PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var JITTER_PROGRESS: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	JITTER_PROGRESS += delta * JITTER_SPEED
	if JITTER_PROGRESS >= 1.0: 
		JITTER_PROGRESS -= 1.0
		JITTER()
		
func JITTER() -> void:
	var LIGHT_RAD: float = randf_range(JITTER_RAD_MIN,JITTER_RAD_MAX)
	var LIGHT_POS: Vector2 = Vector2(
			randf_range(-JITTER_OFFSET, JITTER_OFFSET),
			randf_range(-JITTER_OFFSET, JITTER_OFFSET))
	LIGHT_A.texture_scale = LIGHT_RAD
	LIGHT_B.texture_scale = LIGHT_RAD
	LIGHT_A.position = LIGHT_POS
	LIGHT_B.position = LIGHT_POS
	
