shader_type canvas_item;

uniform float zoom = 1.0;
uniform float boundary = 16;
uniform float max_iterations = 600;

uniform float ratio;

uniform vec2 offset = vec2(.0, .0);

uniform vec4 color1: source_color;
uniform vec4 color2: source_color;

uniform float exponent;

void fragment() {
	vec2 pos = ((UV + offset / zoom) * 2.0 - 1.0) * zoom;
	pos.x *= ratio;
	
	float a = pos.x;
	float b = pos.y;
	
	float copy_a = a;
	float copy_b = b;
	
	float n = .0;
	
	while (n < max_iterations) {
		float A = a*a - b*b;
		float B = 2.0 * a*b;
		a = copy_a + A;
		b = copy_b + B;
		
		if (abs(a + b) > boundary) {
			break;
		}
		n++;
	}
	
	float anim = pow(float(n / max_iterations), exponent);

	COLOR = mix(color1, color2, anim);
}
