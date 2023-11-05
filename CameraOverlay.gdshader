shader_type canvas_item;

uniform float grain;
uniform sampler2D grain_noise: repeat_enable;

uniform float warp;

uniform sampler2D SCREEN: hint_screen_texture;

void fragment() {
	vec2 dc = abs(0.5-SCREEN_UV);
    dc *= dc;
	
	vec2 uv = SCREEN_UV;
	uv.x -= 0.5; uv.x *= 1.0+(dc.y*(0.3*warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0+(dc.x*(0.4*warp)); uv.y += 0.5;
	
	float mask = 1.0 - float(uv.x < .0 ||uv.x > 1.0 || uv.y < .0 || uv.y > 1.0);
	
	vec4 pixel = texture(SCREEN, uv);
	pixel.rgb += texture(TEXTURE, uv).rgb * texture(TEXTURE, uv).a * .5;
	
	COLOR = vec4(pixel.rgb * mask, pixel.a + (1.0 - mask));
	
	float noise_value = texture(grain_noise, uv + TIME * 16.2).r;
	COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * noise_value, grain);
}
