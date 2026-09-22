extends Area2D
signal VALIDITY_CHANGED(VALID: bool)
@export_color_no_alpha var OFF_COLOR: Color = Color.RED
@export_color_no_alpha var ON_COLOR: Color = Color.GREEN
@export_range(0.1, 1.0) var PULSE_FREQ: float = 0.25
@export var SPRITE: Sprite2D
@export var LIGHT: PointLight2D

var PULSE_PROG: float = 0.0
var OBJECT_COUNT: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PULSE_PROG = randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OBJECT_COUNT == 0:
		PULSE_PROG += delta * PULSE_FREQ
		if PULSE_PROG >= 1.0:
			PULSE_PROG -= 1.0
		var COLOR_MOD: float = (cos(PULSE_PROG * TAU) * 0.25) + 0.75
		SPRITE.modulate = Color(
			OFF_COLOR.r * COLOR_MOD,
			OFF_COLOR.g * COLOR_MOD,
			OFF_COLOR.b * COLOR_MOD
	)
		var BRIGHT_MOD: float = (cos(PULSE_PROG * TAU) + 1) / 2 # 0-1 
		LIGHT.texture_scale = (1 * BRIGHT_MOD) + 0.02
		

func _on_body_entered(_body: Node2D) -> void:
	OBJECT_COUNT += 1
	
	LIGHT.color = ON_COLOR
	LIGHT.texture_scale = 1.2
	
	SPRITE.modulate = ON_COLOR

	VALIDITY_CHANGED.emit(true)
func _on_body_exited(_body: Node2D) -> void:
	OBJECT_COUNT -= 1
	if OBJECT_COUNT == 0:
		LIGHT.color = OFF_COLOR
		VALIDITY_CHANGED.emit(false)
		PULSE_PROG = 0.0
		 
