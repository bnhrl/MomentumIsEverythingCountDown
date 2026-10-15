shader_type canvas_item;


uniform vec2 scroll_dir = vec2(1.0, 1.0); 
uniform vec2 offset = vec2(1.0, 1.0);
uniform float rotation = 0.0;

uniform sampler2D noise_texture : source_color, filter_nearest, repeat_enable;
uniform sampler2D noise_twoxture : source_color, filter_nearest, repeat_enable;
uniform sampler2D noise_threexture : source_color, filter_nearest, repeat_enable;

varying vec4 modulate;
varying vec2 world_position;

void vertex() {
	modulate = COLOR;
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

// Borrowed from https://godotshaders.com/snippet/rotate/
vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rot = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rot;
	uv += pivot;
	return uv;
}

// I don't actually know if this is what quantizing is. Don't @ me.
vec4 quantize(vec4 input, float amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

//vec2 quantize(vec2 input, vec2 amount) {
	//input *= amount;
	//input = floor(input);
	//input /= amount;
	//return input;
//}

float quantize(float input, float amount) {
	input *= amount;
	input = floor(input);
	input /= amount;
	return input;
}

void fragment() {
	vec2 uv = world_position * 0.001 + SCREEN_UV * 0.25 + offset;
	uv = rotate(uv, vec2(0.0), rotation);
	uv.x += sin(TIME) * 0.005 * sin(uv.y * 100.0);
	uv.y += sin(TIME) * 0.005 * sin(uv.x * 100.0);
	
	vec4 no2se = texture(noise_twoxture, uv); //+ vec2(TIME * 0.05)
	vec4 noise = texture(noise_texture, uv + vec2(TIME * 0.05) * scroll_dir);
	vec4 noi3e = texture(noise_threexture, uv + vec2(TIME * 0.1) * scroll_dir + no2se.g);
	
	noi3e = quantize(noi3e, 2.0);
	noise.a -= 1.0 - (noi3e.r + noi3e.g + noi3e.b) * 0.5;
	COLOR = modulate * noise;
	COLOR.a = quantize(COLOR.a, 8.0);
}
