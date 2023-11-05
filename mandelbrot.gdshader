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
	
	highp float a = pos.x;
	highp float b = pos.y;
	
	highp float copy_a = a;
	highp float copy_b = b;
	
	float n = .0;
	
	while (n < max_iterations) {
		highp float A = a*a - b*b;
		highp float B = 2.0 * a*b;
		a = copy_a + A;
		b = copy_b + B;
		
		if (abs(a + b) > boundary) {
			break;
		}
		n++;
	}
	
	float anim = pow(float(n / max_iterations), exponent);
	if (n >= max_iterations * .9) {
		n -= max_iterations * .9;
		anim = 1.0 - n / (max_iterations * .9);
	}

	COLOR = mix(color1, color2, anim);
}
