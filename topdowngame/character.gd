extends CharacterBody2D

@export_range(0,1000) var SPEED := 60
$GPUParticles2D
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()


func get_input() -> void:
	var VECTOR = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = VECTOR * SPEED
	pass
	
