shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float rounding = 10.0;

// I don't actually know if this is what quantizing is. Don't @ me.
vec4 quantize(vec4 input, float amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += sin(TIME)*0.01;
	vec4 color = texture(screen_texture, uv);
	color = quantize(color, rounding);
	color.b *= clamp(rounding - 3.5, 0.67, 1.0);
	color.g *= clamp(rounding - 3.5, 0.75, 1.0);
    COLOR = color;
}