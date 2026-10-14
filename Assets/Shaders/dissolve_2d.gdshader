shader_type canvas_item;

uniform sampler2D noise_texture : source_color, filter_nearest;
uniform float progress : hint_range(0.0, 1.0) = 0.0;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	COLOR = COLOR * modulate;
	
	vec4 noise = texture(noise_texture, UV);
	float dissolve = floor(1.0 - progress + noise.r * 0.99);
	COLOR.a *= dissolve;
}
