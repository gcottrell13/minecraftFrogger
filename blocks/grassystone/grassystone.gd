@tool
class_name GrassyStoneBlock
extends FullSolidBlock

@export_color_no_alpha var grass_color:
	set = set_color


func set_color(color: Color):
	grass_color = color;
	if not is_inside_tree():
		return;
		
	var mat : StandardMaterial3D = $up.mesh.surface_get_material(0);
	mat.albedo_color = color;
	
	mat = $north.mesh.surface_get_material(0);
	var shader : ShaderMaterial = mat.next_pass;
	shader.resource_local_to_scene = false;
	shader.set_shader_parameter("color", Vector3(color.r, color.g, color.b));
