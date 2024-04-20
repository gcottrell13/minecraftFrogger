@tool
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super();
	if not Engine.is_editor_hint():
		ControllableManager.set_controllable($Frog, 0);
		CameraManager.add_camera_target($Frog/Camera3D, 0);
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta);
	if not Engine.is_editor_hint():
		pass
