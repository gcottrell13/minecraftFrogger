@tool
class_name GrassBlock
extends SolidBlock

@export_color_no_alpha var grass_color:
	set = set_color

# Called when the node enters the scene tree for the first time.
func _ready():
	super();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color(color: Color):
	grass_color = color;
	var mat : StandardMaterial3D = $top.mesh.surface_get_material(0);
	mat.albedo_color = color;
	
	mat = $north.mesh.surface_get_material(0);
	var shader : ShaderMaterial = mat.next_pass;
	shader.resource_local_to_scene = false;
	shader.set_shader_parameter("color", Vector3(color.r, color.g, color.b));
