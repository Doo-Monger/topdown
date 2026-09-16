class_name MovableObject
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if move_and_slide():
		resolve_collisions()

func apply_impact(IMPACT_VELOCITY: Vector2) -> void:
	velocity = IMPACT_VELOCITY

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var COLLISION := get_slide_collision(i)
		var COLLISION_BODY := COLLISION.get_collider() as MovableObject
		if COLLISION_BODY:
			COLLISION_BODY.apply_impact(velocity)
		else:
			velocity -= velocity.project(COLLISION.get_normal())
