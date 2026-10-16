shader_type canvas_item;
render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.a *= step(0.75, fract(UV.x * 0.25 - TIME * 0.5));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
