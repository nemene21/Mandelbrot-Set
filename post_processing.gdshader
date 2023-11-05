shader_type canvas_item;

uniform float chromatic_abberation = 0.1;
uniform float chrome_exponent = 3.0;
uniform sampler2D SCREEN: hint_screen_texture;

void fragment() {
	float dist = distance(vec2(.5, .5), UV) * 2.0;
	
	vec2 chroma_offset = vec2(1.0, 1.0) * chromatic_abberation * pow(dist, chrome_exponent);
	
	COLOR = vec4(
		texture(SCREEN, SCREEN_UV - chroma_offset).r,
		texture(SCREEN, SCREEN_UV).g,
		texture(SCREEN, SCREEN_UV + chroma_offset).b,
		1.0
	);
}
