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
	if not Engine.is_editor_hint():
		var grass5: GrassBlock = $grass5;
		grass5.position += Vector3(-0.1, 0, 0) * delta;
		#grass5.rotation += Vector3(0, 2.5, 0) * delta;
		grass5.do_face_hiding();
