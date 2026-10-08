class_name TeleporterSource
extends Area2D

@export var sprite: Sprite2D
@export var particles: GPUParticles2D
@export var collision_shape: CollisionShape2D

@export var valid_color: Color = Color(Color.CYAN, 0.5)
@export var invalid_color: Color = Color(Color.MAGENTA, 0.5)

@export var destination: TeleporterDestination

var is_active: bool = true

var objects: Array[InteractiveObject] = []

func _ready() -> void:
	if not destination:
		is_active = false ## "is off" vs "toggle off"
		sprite.modulate = invalid_color
	else:
		destination.validity_changed.connect(_on_destination_validity_changed)
		sprite.modulate = valid_color
		destination.sprite.modulate = valid_color
		particles.modulate = valid_color
		destination.particles.modulate = valid_color
func _physics_process(_delta: float) -> void:
	if not is_active or objects.is_empty():
		return
	var own_rect: Rect2 = collision_shape.shape.get_rect()
	own_rect.position += position
	for object in objects:
		if own_rect.encloses(object.get_current_rect()):
			object.displace(destination.position - position)
			particles.emitting = true
			destination.particles.emitting = true

func _on_destination_validity_changed(valid: bool) -> void:
	is_active = valid
	var color: Color = valid_color if valid else invalid_color 
	sprite.modulate = color
	destination.sprite.modulate = color	
func _toggle_on() -> void:
	is_active = true
	sprite.modulate = valid_color
func _toggle_off() -> void:
	is_active = false
	sprite.modulate = invalid_color

func _on_body_entered(body: Node2D) -> void:
	var object: InteractiveObject = body as InteractiveObject
	if object:
		objects.push_back(object) #goofy ass name for a simple array appending method
func _on_body_exited(body: Node2D) -> void:
	var index_to_remove: int = objects.find(body as InteractiveObject)
	if index_to_remove >= 0:
		objects.remove_at(index_to_remove)
		
