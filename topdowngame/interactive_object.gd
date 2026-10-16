class_name InteractiveObject
extends CharacterBody2D

@export var collision_shape: CollisionShape2D

func get_current_rect() -> Rect2:
	var rect: Rect2 = collision_shape.shape.get_rect()
	rect.position += position
	return rect

func displace(offset: Vector2) -> void:
	position += offset
func displace_to(destination: Vector2) -> void:
	position = destination
