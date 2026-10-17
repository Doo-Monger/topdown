class_name TeleporterSource
extends MapObject

@export var sprite: Sprite2D
@export var particles: GPUParticles2D
@export var collision_shape: CollisionShape2D
@export var line: Line2D

@export var valid_color: Color = Color(Color.CYAN, 0.5)
@export var invalid_color: Color = Color(Color.DARK_RED, 0.5)

@export var destination: TeleporterDestination

@export var pulse_freq: float = 1.5
var pulse_prog: float = 0.0

var objects: Array[InteractiveObject] = []

func _process(delta: float) -> void:
	if not is_active:
		_toggle_off()
	if is_active:
		pulse_prog += pulse_freq * delta
		if pulse_prog >= 1:
			pulse_prog -= 1
		var color_mod: float = (0.2*(cos(pulse_prog * TAU) + 1) / 2) + 0.6 # 0-1 
		sprite.modulate = Color(
			valid_color.r * color_mod,
			valid_color.g * color_mod,
			valid_color.b * color_mod
	)
	if player_in_range or destination.player_in_range:
		var distance_to_character: float
		if player_in_range:
			distance_to_character= character.position.distance_to(self.global_position)
			line.default_color.a = 1 - distance_to_character/player_detect_max 
		else:
			distance_to_character = destination.character.position.distance_to(destination.global_position)
		line.default_color.a = 1 - distance_to_character/player_detect_max

func _ready() -> void:
	if not destination:
		_toggle_off()
	else:
		destination.validity_changed.connect(_on_validity_changed)
		line.add_point(Vector2.ZERO)
		prints("line add destination position = ", destination.position)
		line.add_point(destination.position - position)
		super()
		_toggle_on()
	
func _physics_process(_delta: float) -> void:
	if not is_active or objects.is_empty():
		set_physics_process(false)
		return
	var own_rect: Rect2 = collision_shape.shape.get_rect()
	#.get_rect() returns coordinates relative to teleporter itself, necessitating
	#adding it with the position of the teleporter. 
	own_rect.position += position 
	for object in objects:
		if own_rect.encloses(object.get_current_rect()):
			prints("teleport destination position = ", destination.position)
			object.displace_to(destination.position)
			particles.emitting = true
			destination.particles.emitting = true

func _on_validity_changed(valid: bool) -> void:
	if valid:
		_toggle_on()
	else:
		_toggle_off()

func _toggle_on() -> void:
	set_physics_process(true)
	is_active = true
	sprite.modulate = valid_color
	destination.sprite.modulate = valid_color
	particles.modulate = valid_color
	destination.particles.modulate = valid_color
	line.modulate = valid_color
	pulse_prog = 0.5
func _toggle_off() -> void:
	set_physics_process(false)
	is_active = false
	sprite.modulate = invalid_color
	destination.sprite.modulate = invalid_color
	line.modulate = invalid_color

func _on_body_entered(body: Node2D) -> void:
	var object: InteractiveObject = body as InteractiveObject
	if object:
		objects.push_back(object) #goofy ass name for a simple array appending method
		set_physics_process(true)
func _on_body_exited(body: Node2D) -> void:
	var index_to_remove: int = objects.find(body as InteractiveObject)
	if index_to_remove >= 0: #.find returns -1 if no matching object found
		objects.remove_at(index_to_remove)
		#
##func _on_area_2d_body_entered(body: PlayerCharacter) -> void:
	##player_in_range = true
	##player = body
##func _on_area_2d_body_exited(body: Node2D) -> void:
	##player_in_range = false
	##line.default_color.a = 0
