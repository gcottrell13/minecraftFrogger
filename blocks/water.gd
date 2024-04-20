@tool
class_name WaterBlock
extends BaseBlock


var water_frames = [
	[0, 1],
	[1, 1],
	[0, 2],
	[1, 2],
];

var frame_counter = 0;
var frame_timer = 0;
@export var WATER_SPEED_FPS : float = 2;

func _ready():
	super();
	if $top.visible:
		$top.mesh.center_offset.y = -0.1;


func _process(delta):
	super(delta);
	
	frame_timer += delta;
	if frame_timer < 1.0 / WATER_SPEED_FPS:
		return;
	frame_timer -= 1.0 / WATER_SPEED_FPS;
	frame_counter = (frame_counter + 1) % water_frames.size();
	var data = water_frames[frame_counter];
	for child in get_children():
		if child is MeshInstance3D:
			var mat : StandardMaterial3D = child.mesh.surface_get_material(0);
			mat.uv1_offset = Vector3(data[0] * 0.05, data[1] * 0.05, 0);


func do_face_hiding(RECURSE = 1, updater: float = 0):
	$top.mesh.center_offset.y = 0;
	super(RECURSE, updater);
	if $top.visible:
		$top.mesh.center_offset.y = -0.1;
