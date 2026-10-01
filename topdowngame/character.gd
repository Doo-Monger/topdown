class_name PlayerCharacter
extends InteractiveObject

var last_position: Vector2
var travel_distance := 0.0 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
		


@export_range(0,1000) var SPEED := 60
func _physics_process(delta: float) -> void:
	get_input()
	if move_and_slide():
		resolve_collisions()

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var COLLISION := get_slide_collision(i)
		var COLLISION_BODY : MovableObject = COLLISION.get_collider() as MovableObject
		if COLLISION_BODY:
				# print(COLLISION.get_normal())
				COLLISION_BODY.apply_impact(velocity)
func get_input() -> void:
	var VECTOR : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not Main.animation_is_playing:
		velocity = VECTOR * SPEED
	else: 
		velocity = Vector2.ZERO
	pass
	
