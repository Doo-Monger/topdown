extends MapObject
@export var bound_object: MapObject

var pressed: bool = false

func _ready() -> void:
	super()
	if bound_object:
		bound_object.button_toggle(false)
func _process(_delta: float) -> void:
	if player_in_range and not pressed:
		_on_pressed()

func _on_pressed() -> void:
	pressed = true
	self.modulate = Color.DARK_GRAY
	if bound_object:
		bound_object.button_toggle(true)
