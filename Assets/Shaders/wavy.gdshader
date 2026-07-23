shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform bool on_canvas_group = false;
uniform float wave_x = 10.0;
uniform float wave_y = 10.0;
uniform float ferocity = 1.0;
uniform float speed = 1.0;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, uv);
	if (on_canvas_group) { uv = SCREEN_UV; }
	uv.x += sin(TIME*speed) * ferocity / 10.0 * sin(uv.y*wave_x);
	uv.y += sin(TIME*speed) * ferocity / 10.0 * sin(uv.x*wave_y);
	if (on_canvas_group) { color = texture(screen_texture, uv); }
	COLOR = color*modulate;
}