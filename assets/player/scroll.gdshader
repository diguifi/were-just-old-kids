shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 0.0);
uniform float speed_scale = 0.5;
uniform float time = 0.0;

void fragment() {

	vec2 move = direction * time * speed_scale;
	COLOR = texture(TEXTURE, UV + move);
	
}