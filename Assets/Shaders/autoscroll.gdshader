shader_type canvas_item;

// Set Repeat to "Enabled" on the CanvasItem node!
uniform vec2 multiply = vec2(1.0);

void fragment() {
	vec2 uv = UV + vec2(TIME) * multiply;
	vec4 color = texture(TEXTURE, uv);
	COLOR = color;
}
