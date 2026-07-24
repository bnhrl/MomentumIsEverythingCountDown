shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float rounding = 2;

float round_to_decimal(float num) {
    return round(num * pow(10.0, float(rounding))) / pow(10.0, float(rounding));
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	color.r = round_to_decimal(color.r);
	color.g = round_to_decimal(color.g);
	color.b = round_to_decimal(color.b);
    COLOR = color;
}