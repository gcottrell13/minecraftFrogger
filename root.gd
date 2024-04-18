extends Node3D


@onready var camera: InterpolatedCamera3D = $Camera;
var lightAngle = 0;
var height = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var camera_targets = CameraManager.get_camera_targets(get_tree());
	if camera_targets.size() == 1:
		camera.target = camera_targets[0];
	
	# $ShapeCast3D.position = camera.project_position(DisplayServer.window_get_size() / 2, 1);
