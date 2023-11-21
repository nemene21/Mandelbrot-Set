shader_type canvas_item;

uniform float zoom = 1.0;
uniform float boundary = 16;
uniform float max_iterations = 600;

uniform int samples = 8;

uniform float ratio;

uniform vec2 offset = vec2(.0, .0);

uniform vec4 color1: source_color;
uniform vec4 color2: source_color;

uniform float exponent;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 calculate(vec2 pos) {
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
	return vec3(a, b, n);
}

void fragment() {
	vec2 pos = ((UV + offset / zoom) * 2.0 - 1.0) * zoom;
	pos.x *= ratio;
	
	vec3 z = vec3(.0, .0, .0);
	for (int i = 0; i < samples; i++) {
		z += calculate(pos + random(UV + float(i)) * 0.001 * zoom);
	}
	z /= float(samples);
	
	float anim = pow(z.z / max_iterations, exponent);
	if (z.z >= max_iterations - 1.0) {
		anim = .0;
	}
	
	COLOR = mix(color1, color2, anim);
}
