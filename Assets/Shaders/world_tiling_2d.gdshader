shader_type canvas_item;

uniform sampler2D tile_texture: source_color, repeat_enable, filter_nearest; 
uniform vec2 tile_size = vec2(16, 16);

varying vec2 world_position;
varying vec4 modulate;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	modulate = COLOR;
}

void fragment() {
	vec2 world_uv = world_position / tile_size;
	
	COLOR = texture(tile_texture, world_uv) * modulate;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
