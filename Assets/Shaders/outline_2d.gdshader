// Adapted from https://godotshaders.com/shader/2d-outline-stroke/
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
global uniform vec4 outline_color : source_color = vec4(1); // Project -> Project Settings -> Globals -> Shader Globals

uniform bool on_canvas_group = true;
uniform float outline_thickness : hint_range(0, 10) = 1.0;

void fragment() {
	if (on_canvas_group) {
		vec2 size = SCREEN_PIXEL_SIZE * outline_thickness;
		
		float outline = texture(screen_texture, SCREEN_UV + vec2(-size.x, 0)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(0, size.y)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(size.x, 0)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(0, -size.y)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(-size.x, size.y)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(size.x, size.y)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(-size.x, -size.y)).a;
		outline += texture(screen_texture, SCREEN_UV + vec2(size.x, -size.y)).a;
		outline = min(outline, 1.0);
		
		vec4 color = texture(screen_texture, SCREEN_UV);
		COLOR = mix(color, outline_color, outline - color.a);
	} else {
		vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
		
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		outline = min(outline, 1.0);
		
		vec4 color = texture(TEXTURE, UV);
		COLOR = mix(color, outline_color, outline - color.a);
	}
}