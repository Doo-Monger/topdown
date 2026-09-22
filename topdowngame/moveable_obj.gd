class_name MovableObject
extends CharacterBody2D
@export_range (0.0, 10.0) var drag := 5.0
@export_range (0.0, 1.0) var impact_response := 0.5 
@export var initial_velocity := Vector2.ZERO

func _ready() -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	if velocity.length_squared() >= 1.0:
		velocity *= 1.0 - (drag * delta)
		if move_and_slide():
			resolve_collisions()
	else:
		position = round(position)
		velocity = Vector2.ZERO
			

func apply_impact(IMPACT_VELOCITY: Vector2) -> void:
	velocity += (IMPACT_VELOCITY - velocity) * impact_response

func resolve_collisions() -> void:
	var CURRENT_VELOCITY := velocity
	for i in get_slide_collision_count():
		var COLLISION := get_slide_collision(i)
		var COLLISION_BODY := COLLISION.get_collider() as MovableObject
		if COLLISION_BODY:
			apply_impact(COLLISION_BODY.velocity)
			COLLISION_BODY.apply_impact(CURRENT_VELOCITY)
		else:
			velocity -= velocity.project(COLLISION.get_normal())
