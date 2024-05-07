shader_type canvas_item;

uniform vec4 color = vec4(1,1,1,1);
uniform float flashstate : hint_range(0,1) = 0.5;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(pixelColor, color, flashstate);
	COLOR.a *= pixelColor.a;
}