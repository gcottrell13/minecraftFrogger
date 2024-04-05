extends Node3D


@onready var light = $OmniLight3D;
@onready var camera: InterpolatedCamera3D = $Camera;
var lightAngle = 0;
var height = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	light.position.y = height + 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var camera_targets = CameraManager.get_camera_targets(get_tree());
	if camera_targets.size() == 1:
		camera.target = camera_targets[0];
	
	
	lightAngle += delta;
	light.position.x = sin(lightAngle / 2) * 20;
	light.position.z = cos(lightAngle * 1.5) * 20;
	
