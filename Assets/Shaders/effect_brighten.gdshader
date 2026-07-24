shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float mult: hint_range(0.0, 2.0) = 0.0;

varying vec4 modulate;


void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec3 grayscale = mix(vec3((color.r + color.g + color.b) / 3.0),  vec3(0.3 * color.r + 0.6 * color.g + 0.1 * color.b), 1.0);
	color.rgb += grayscale * mult;
	COLOR = color;
}
