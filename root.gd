class_name Root
extends Node3D


@onready var camera: InterpolatedCamera3D = $Camera;
@onready var playArea: Node3D = $PlayArea;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var camera_targets = CameraManager.get_camera_targets(get_tree());
	if camera_targets.size() == 1:
		camera.target = camera_targets[0];
	
	# $ShapeCast3D.position = camera.project_position(DisplayServer.window_get_size() / 2, 1);


func _on_level_select_on_click_level(scene: PackedScene):
	for child in playArea.get_children():
		playArea.remove_child(child);
	var instance: Level = scene.instantiate();
	playArea.add_child(instance);
	instance.spawn_characters(0, preload("res://characters/frog1/frog.tscn"));
