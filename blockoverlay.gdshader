shader_type spatial;

uniform sampler2D overlay : filter_nearest_mipmap;
uniform vec2 uv_aa;
uniform vec2 uv_size;
uniform vec3 color : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(overlay, UV * uv_size + uv_aa);
	ALPHA = 0.0;
	if (tex.w > 0.0) {
		ALBEDO.xyz = tex.xyz * color;
		ALPHA = tex.w;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
