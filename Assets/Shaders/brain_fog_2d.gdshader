shader_type canvas_item;


uniform sampler2D noise_texture : source_color, filter_nearest, repeat_enable;
uniform sampler2D noise_twoxture : source_color, filter_nearest, repeat_enable;
uniform sampler2D noise_threexture : source_color, filter_nearest, repeat_enable;

varying vec4 modulate;
varying vec2 world_position;

void vertex() {
	modulate = COLOR;
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec4 quantize(vec4 input, float amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

vec2 quantize(vec2 input, vec2 amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

float quantize(float input, float amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

void fragment() {
	vec2 uv = world_position * 0.001 + SCREEN_UV * 0.25;
	uv.x += sin(TIME) * 0.005 * sin(uv.y * 100.0);
	uv.y += sin(TIME) * 0.005 * sin(uv.x * 100.0);
	
	vec4 no2se = texture(noise_twoxture, uv); //+ vec2(TIME * 0.05)
	vec4 noise = texture(noise_texture, uv + vec2(TIME * 0.05));
	vec4 noi3e = texture(noise_threexture, uv + vec2(TIME * 0.1) + no2se.g);
	
	noi3e = quantize(noi3e, 2.0);
	noise.a -= 1.0 - (noi3e.r + noi3e.g + noi3e.b) * 0.5;
	COLOR = modulate * noise;
	COLOR.a = quantize(COLOR.a, 8.0);
}
