shader_type canvas_item;

uniform sampler2D tex : source_color, filter_nearest, repeat_enable;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}


void fragment() {
	vec2 uv = SCREEN_UV + vec2(TIME)*0.01;
	COLOR = texture(tex, uv)*modulate;
}